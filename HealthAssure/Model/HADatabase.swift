//
//  HADatabase.swift
//  HealthAssure
//
//  Created by Mohd Aslam on 13/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HADatabase: NSObject {
    static let shared = HADatabase()
    
    func copyDatabaseIfNeeded() {
        let fileManager = FileManager.default
        let dbPath = HAUtils.getDocumentDirectoryPath() + "/HealthAssure.sqlite";
        print(dbPath)
        if fileManager.fileExists(atPath: dbPath) {
            return
        }
        let sourcePath = Bundle.main.resourcePath! + "/HealthAssure.sqlite"
        print(sourcePath)
        do {
            // copy files from main bundle to documents directory
            try
                fileManager.copyItem(atPath: sourcePath, toPath: dbPath)
        } catch let error as NSError {
            // Catch fires here, with an NSError being thrown
            print("error occurred, here are the details:\n \(error)")
        }
    }
    
    func openDatabase() -> FMDatabase {
        let path = HAUtils.getDocumentDirectoryPath() + "/HealthAssure.sqlite";
        let database = FMDatabase(path: path)
        return database
    }
    
    
    //Call on Logout
    func updateDatabaseOnUserLogout() {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        let query1 = "delete from UserProfile"
        if !database.executeStatements(query1) {
            print(database.lastError(), database.lastErrorMessage())
        }
        let query2 = "delete from FamilyDetails"
        if !database.executeStatements(query2) {
            print(database.lastError(), database.lastErrorMessage())
        }
        let query3 = "delete from AppointmentDetails"
        if !database.executeStatements(query3) {
            print(database.lastError(), database.lastErrorMessage())
        }
        let query4 = "delete from Provider"
        if !database.executeStatements(query4) {
            print(database.lastError(), database.lastErrorMessage())
        }
        let query5 = "delete from ProviderNearService"
        if !database.executeStatements(query5) {
            print(database.lastError(), database.lastErrorMessage())
        }
        let query6 = "delete from User_Facility_Subservice"
        if !database.executeStatements(query6) {
            print(database.lastError(), database.lastErrorMessage())
        }
        let query7 = "delete from StateCityTable"
        if !database.executeStatements(query7) {
            print(database.lastError(), database.lastErrorMessage())
        }
        
        database.close()
    }
    
    //MARK:- Write into Database
    
    //Save User Profile Data
    func saveUserProfile(dict:NSDictionary) {
        self.copyDatabaseIfNeeded()
        
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        let userId = (dict["user_id"] as? String) ?? ""
        let userStatus = (dict["userstatus"] as? String) ?? ""
        
        let userRelationsArr = dict.value(forKey: "relationdetails") as! NSArray
        var relationIds = ""
        if userRelationsArr.count > 0 {
            relationIds = self.combinedServices(services: userRelationsArr, key: "id")
        }
        
        if let profileDict = dict["profile_details"] as? NSDictionary {
            let firstname = (profileDict["name"] as? String) ?? ""
            let username = (profileDict["email"] as? String) ?? ""
            let mobile = (profileDict["mobile_number"] as? String) ?? ""
            let empId = (profileDict["employee_id"] as? String) ?? ""
            let empType = (profileDict["employee_type"] as? String) ?? ""
            let empRoll = (profileDict["employee_role"] as? String) ?? ""
            let dob = (profileDict["dob"] as? String) ?? ""
            let gender = (profileDict["gender"] as? String) ?? ""
            let profileImg = (profileDict["ProfileImage"] as? String) ?? ""
            let memberId = (profileDict["member_id"] as? String) ?? ""
            
            var query = "INSERT INTO UserProfile ('UserLoginId', 'FirstName', 'UserName', 'MobileNumber', 'EmpNo', 'UserTypeId', 'UserRoleId', 'Status', 'DOB', 'Gender', 'ProfileImage', 'member_id', 'UserRelation') VALUES ('\(userId)', '\(firstname)', '\(username)', '\(mobile)', '\(empId)', '\(empType)', '\(empRoll)', '\(userStatus)', '\(dob)', '\(gender)', '\(profileImg)', '\(memberId)', '\(relationIds)')"
            
            if empRoll.uppercased() == "HR" || empRoll.capitalized == "Provider"  {
                let clientName = (profileDict["client_name"] as? String) ?? ""
                let clientAddress = (profileDict["client_address"] as? String) ?? ""
                let clientArea = (profileDict["area"] as? String) ?? ""
                let clientCity = (profileDict["city"] as? String) ?? ""
                let clientState = (profileDict["state"] as? String) ?? ""
                let clientPincode = (profileDict["pincode"] as? String) ?? ""
                let contactPerson = (profileDict["contact_person"] as? String) ?? ""
                let contactNumber = (profileDict["contact_no"] as? String) ?? ""
                let contactEmail = (profileDict["contact_email"] as? String) ?? ""
                let contactLandline = (profileDict["contact_landline"] as? String) ?? ""
                let panNo = (profileDict["PANNo"] as? String) ?? ""
                query = "INSERT INTO UserProfile ('UserLoginId', 'FirstName', 'UserName', 'MobileNumber', 'EmpNo', 'UserTypeId', 'UserRoleId', 'Status', 'DOB', 'Gender', 'ProfileImage', 'member_id', 'ClientName', 'ClientAddress', 'Area', 'City', 'State', 'Pincode', 'ContactPerson', 'ContactNo', 'ContactEmail', 'ContactLandline', 'PANNo', 'UserRelation') VALUES ('\(userId)', '\(firstname)', '\(username)', '\(mobile)', '\(empId)', '\(empType)', '\(empRoll)', '\(userStatus)', '\(dob)', '\(gender)', '\(profileImg)', '\(memberId)', '\(clientName)', '\(clientAddress)', '\(clientArea)', '\(clientCity)', '\(clientState)', '\(clientPincode)', '\(contactPerson)', '\(contactNumber)', '\(contactEmail)', '\(contactLandline)', '\(panNo)', '\(relationIds)')"
            }
            if !database.executeStatements(query) {
                print("Failed to insert initial data into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
            
            database.close()
        }
        
        self.saveFamilyDetails(dict: dict)
    }
    
    //Save Family Details
    func saveFamilyDetails(dict:NSDictionary) {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        let userId = (dict["user_id"] as? String) ?? ""
        let familyDetail = dict.value(forKey: "family_details") as! NSArray
        
        if familyDetail.count > 0 {
            for i in 0..<familyDetail.count {
                let relationId = ((familyDetail.object(at: i) as! NSDictionary).value(forKey: "relation_id") as? Int) ?? 0
                let name = ((familyDetail.object(at: i) as! NSDictionary).value(forKey: "name")) ?? ""
                let mobile = ((familyDetail.object(at: i) as! NSDictionary).value(forKey: "mobile_number")) ?? ""
                let email = ((familyDetail.object(at: i) as! NSDictionary).value(forKey: "email")) ?? ""
                let memberId = ((familyDetail.object(at: i) as! NSDictionary).value(forKey: "member_id")) ?? ""
                let dob = ((familyDetail.object(at: i) as! NSDictionary).value(forKey: "dob")) ?? ""
                let gender = ((familyDetail.object(at: i) as! NSDictionary).value(forKey: "gender")) ?? ""
                let buyPlan = ((familyDetail.object(at: i) as! NSDictionary).value(forKey: "BuyPlan")) ?? ""
                
                var query = "INSERT INTO FamilyDetails ('UserLoginId', 'RelationId', 'Name', 'MobileNumber', 'EmailId', 'MemberId', 'DOB', 'Gender', 'BuyPlan') VALUES ('\(userId)', '\(relationId)', '\(name)', '\(mobile)', '\(email)', '\(memberId)', '\(dob)', '\(gender)', '\(buyPlan)')"
                
                if relationId == 8 || relationId == 9 || relationId == 17 {
                    var relationType = ""
                    if relationId == 8 {
                        relationType = "Son"
                    }
                    else if relationId == 9 {
                        relationType = "Daughter"
                    }
                    else if relationId == 17 {
                        relationType = "Other"
                    }
                    query = "INSERT INTO FamilyDetails ('UserLoginId', 'RelationId', 'Name', 'MobileNumber', 'EmailId', 'MemberId', 'DOB', 'Gender', 'BuyPlan', 'RelationType') VALUES ('\(userId)', '\(relationId)', '\(name)', '\(mobile)', '\(email)', '\(memberId)', '\(dob)', '\(gender)', '\(buyPlan)', '\(relationType)')"
                }
                
                if !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
            }
        }
        
        database.close()
    }
    
    //save service provider data
    func SaveServiceProviderData(providerList: NSArray) {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return
        }
        if providerList.count > 0 {
            //Delete Provider data
            let deleteQuery = "delete from Provider"
            if !database.executeStatements(deleteQuery) {
                print(database.lastError(), database.lastErrorMessage())
            }
            //Delete Provider data
            let deleteQuery1 = "delete from User_Facility_Subservice"
            if !database.executeStatements(deleteQuery1) {
                print(database.lastError(), database.lastErrorMessage())
            }
            
            //Insert data
            for i in 0..<providerList.count {
                let providerId = ((providerList.object(at: i) as! NSDictionary).value(forKey: "provider_id")) ?? ""
                let providerName = ((providerList.object(at: i) as! NSDictionary).value(forKey: "provicer_name")) ?? ""
                let address = ((providerList.object(at: i) as! NSDictionary).value(forKey: "address")) ?? ""
                let mobile = ((providerList.object(at: i) as! NSDictionary).value(forKey: "contact_number")) ?? ""
                let lati = ((providerList.object(at: i) as! NSDictionary).value(forKey: "latitude")) ?? ""
                let longi = ((providerList.object(at: i) as! NSDictionary).value(forKey: "longitude")) ?? ""
                let iconSmallUrl = ((providerList.object(at: i) as! NSDictionary).value(forKey: "icon_image_small_url")) ?? ""
                let iconUrl = ((providerList.object(at: i) as! NSDictionary).value(forKey: "icon_image_url")) ?? ""
                let galleryThumbImgUrl = ((providerList.object(at: i) as! NSDictionary).value(forKey: "gallery_thumbnail_image_url")) ?? ""
                let galleryArr: [String] = (((providerList.object(at: i) as! NSDictionary).value(forKey: "gallery_image_url")) as? [String])!
                
                var galleryImgUrl = ""
                if galleryArr.count > 0 {
                    galleryImgUrl = galleryArr.joined(separator: ",")
                }
                let providerRating = ((providerList.object(at: i) as! NSDictionary).value(forKey: "Provider_Rate")) ?? ""
                let city = ((providerList.object(at: i) as! NSDictionary).value(forKey: "City")) ?? ""
                let state = ((providerList.object(at: i) as! NSDictionary).value(forKey: "State")) ?? ""
                let ratingAllow = ((providerList.object(at: i) as! NSDictionary).value(forKey: "RatingAllow")) ?? ""
                let credit = ((providerList.object(at: i) as! NSDictionary).value(forKey: "Credit") as? Int) ?? 0
                let providerCredit = ((providerList.object(at: i) as! NSDictionary).value(forKey: "Provider_Credit") as? Int) ?? 0
                let availableServices = ((providerList.object(at: i) as! NSDictionary).value(forKey: "available_services")) as! NSArray
                var services = ""
                if availableServices.count > 0 {
                    services = self.combinedServices(services: availableServices, key: "MainService")
                    //Insert Sub services
                    for i in 0..<availableServices.count {
                        let facilityId = ((availableServices.object(at: i) as! NSDictionary).value(forKey: "MainService")) ?? ""
                        let subServices: [String] = ((availableServices.object(at: i) as! NSDictionary).value(forKey: "SubService")) as! [String]
                        var combinedSubServices = ""
                        if subServices.count > 0 {
                            combinedSubServices = subServices.joined(separator: ",")
                        }
                        let query = "INSERT INTO User_Facility_Subservice ('ProviderId', 'FacilityId', 'FacilitySubServices') VALUES ('\(providerId)', '\(facilityId)', '\(combinedSubServices)')"
                        if !database.executeStatements(query) {
                            print("Failed to insert initial data into the database.")
                            print(database.lastError(), database.lastErrorMessage())
                        }
                    }
                    
                }
                let query = "INSERT INTO Provider ('Provider_id', 'Provider_name', 'Address', 'Contact_number', 'Latitude', 'Longitude', 'Icon_small_url', 'Icon_url', 'Gallery_thumbnail_image_url', 'Gallery_image_url', 'Provider_rating', 'City', 'State', 'Rating_allow', 'Credit', 'ProviderCredit', 'Available_services') VALUES ('\(providerId)', '\(providerName)', '\(address)', '\(mobile)', '\(lati)', '\(longi)', '\(iconSmallUrl)', '\(iconUrl)', '\(galleryThumbImgUrl)', '\(galleryImgUrl)', '\(providerRating)', '\(city)', '\(state)', '\(ratingAllow)', '\(credit)', '\(providerCredit)', '\(services)')"
                
                if !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
                
            }
        }
        
        database.close()
    }
    
    func combinedServices(services: NSArray, key: String) -> String {
        var listStrings = [String]()
        for i in 0..<services.count {
            let service: String = ((services.object(at: i) as! NSDictionary).value(forKey: key) as! String)
            listStrings.append(service)
        }
        var combinedServices = ""
        if listStrings.count > 0 {
            combinedServices = listStrings.joined(separator: ",")
        }
        
        return combinedServices
    }
    
    //Save package details data
    func SavePackageDetails(packageDetails: NSArray) {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return
        }
        
        let deleteQuery = "Delete from FacilitySubService Where FacilityCode = 'HC'"
        if !database.executeStatements(deleteQuery) {
            print(database.lastError(), database.lastErrorMessage())
        }
        let updateQuery = "UPDATE FacilitySubService SET isActive = '\(false)'"
        if !database.executeStatements(updateQuery) {
            print(database.lastError(), database.lastErrorMessage())
        }
        
        //Insert Data
        for i in 0..<packageDetails.count {
            let subArray = ((packageDetails.object(at: i) as! NSDictionary).value(forKey: "service_details")) as! NSArray
            for i in 0..<subArray.count {
                let serviceName = ((subArray.object(at: i) as! NSDictionary).value(forKey: "Service_Name")) ?? ""
                let facilityId = ((subArray.object(at: i) as! NSDictionary).value(forKey: "service_id")) ?? ""
                let subServiceArr = ((subArray.object(at: i) as! NSDictionary).value(forKey: "sub_services")) as! NSArray
                var isSubService: Bool = false
                if subServiceArr.count > 0 {
                    isSubService = true
                }
                
                let totalAvailable = ((subArray.object(at: i) as! NSDictionary).value(forKey: "total_available") as? Int) ?? 0
                let consumed = ((subArray.object(at: i) as! NSDictionary).value(forKey: "consumed") as? Int) ?? 0
                let healthCredit = ((subArray.object(at: i) as! NSDictionary).value(forKey: "health_credit") as? Float) ?? 0.0
                let displayOrder = ((subArray.object(at: i) as! NSDictionary).value(forKey: "DisplayOrder") as? Int) ?? 0
                let unlimited = ((subArray.object(at: i) as! NSDictionary).value(forKey: "UnLimited")) ?? ""
                let isActive: Bool = true
                let facilityCode = ((subArray.object(at: i) as! NSDictionary).value(forKey: "FacilityCode") as? String) ?? ""
                
                let updateSubserviceQuery = "UPDATE FacilityServices SET FacilityName = '\(serviceName)',FacilityId = '\(facilityId)',isSubService = '\(isSubService)',TotalAvailable = '\(totalAvailable)',Consumed = '\(consumed)', HealthCredit = '\(healthCredit)', display_order = '\(displayOrder)', UnLimited = '\(unlimited)', isActive = '\(isActive)' WHERE FacilityCode = '\(facilityCode)'"
                if !database.executeStatements(updateSubserviceQuery) {
                    print(database.lastError(), database.lastErrorMessage())
                }
                
                //Inser Sub services
                for i in 0..<subServiceArr.count {
                    let subFacilityName = ((subServiceArr.object(at: i) as! NSDictionary).value(forKey: "Service_Name")) ?? ""
                    let subFacilityId = ((subServiceArr.object(at: i) as! NSDictionary).value(forKey: "service_id")) ?? ""
                    let subTotalAvailable = ((subServiceArr.object(at: i) as! NSDictionary).value(forKey: "total_available") as? Int) ?? 0
                    let subConsumed = ((subServiceArr.object(at: i) as! NSDictionary).value(forKey: "consumed") as? Int) ?? 0
                    let subHealthCredit = ((subServiceArr.object(at: i) as! NSDictionary).value(forKey: "health_credit") as? Float) ?? 0.0
                    let subFacilityCode = ((subServiceArr.object(at: i) as! NSDictionary).value(forKey: "FacilityCode") as? String) ?? ""
                    
                    if facilityCode != "HC" {
                        let updateSubserviceQuery = "UPDATE FacilitySubService SET FacilityName = '\(subFacilityName)',FacilityId = '\(subFacilityId)', TotalAvailable = '\(subTotalAvailable)',Consumed = '\(subConsumed)', HealthCredit = '\(subHealthCredit)', FacilityServiceId = '\(facilityId)', UnLimited = '\(unlimited)', isActive = '\(isActive)' WHERE FacilityCode = '\(subFacilityCode)'"
                        if !database.executeStatements(updateSubserviceQuery) {
                            print(database.lastError(), database.lastErrorMessage())
                        }
                    }
                    else {
                        let categoryList = ((subServiceArr.object(at: i) as! NSDictionary).value(forKey: "CategoryList")) as! NSArray
                        
                        var categories = ""
                        if categoryList.count > 0 {
                            let jsonData =  try! JSONSerialization.data(withJSONObject: categoryList, options: .prettyPrinted)
                            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                                categories = JSONString as String
                                print(categories)
                            }
                        }
                        
                        let insertCategoryQuery = "INSERT INTO FacilitySubService ('FacilityName', 'FacilityId', 'TotalAvailable', 'Consumed', 'HealthCredit', 'FacilityServiceId', 'FacilityType', 'ServiceType', 'isActive', 'FacilityCode', 'UnLimited', 'CategoryService') VALUES ('\(subFacilityName)', '\(subFacilityId)', '\(subTotalAvailable)', '\(subConsumed)', '\(subHealthCredit)', '\(facilityId)', 'Diagnostics', 'SUBSERVICE', '\(true)', 'HC', '\(unlimited)', '\(categories)')"
                        
                        if !database.executeStatements(insertCategoryQuery) {
                            print(database.lastError(), database.lastErrorMessage())
                        }
                    }
                }
            }
        }
        
        database.close()
    }
    
    //Insert Service Provider Near By Data
    func SaveServiceProviderNearByData(providerList: NSArray) {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return
        }
        if providerList.count > 0 {
            //Delete Provider data
            let deleteQuery = "delete from ProviderNearService"
            if !database.executeStatements(deleteQuery) {
                print(database.lastError(), database.lastErrorMessage())
            }
            
            //Insert data
            for i in 0..<providerList.count {
                let providerId = ((providerList.object(at: i) as! NSDictionary).value(forKey: "provider_id")) ?? ""
                let providerName = ((providerList.object(at: i) as! NSDictionary).value(forKey: "provicer_name")) ?? ""
                let address = ((providerList.object(at: i) as! NSDictionary).value(forKey: "address")) ?? ""
                let mobile = ((providerList.object(at: i) as! NSDictionary).value(forKey: "contact_number")) ?? ""
                let lati = ((providerList.object(at: i) as! NSDictionary).value(forKey: "latitude")) ?? ""
                let longi = ((providerList.object(at: i) as! NSDictionary).value(forKey: "longitude")) ?? ""
                let iconSmallUrl = ((providerList.object(at: i) as! NSDictionary).value(forKey: "icon_image_small_url")) ?? ""
                let iconUrl = ((providerList.object(at: i) as! NSDictionary).value(forKey: "icon_image_url")) ?? ""
                let galleryThumbImgUrl = ((providerList.object(at: i) as! NSDictionary).value(forKey: "gallery_thumbnail_image_url")) ?? ""
                let galleryArr: [String] = (((providerList.object(at: i) as! NSDictionary).value(forKey: "gallery_image_url")) as? [String])!
                
                var galleryImgUrl = ""
                if galleryArr.count > 0 {
                    galleryImgUrl = galleryArr.joined(separator: ",")
                }
                let providerRating = ((providerList.object(at: i) as! NSDictionary).value(forKey: "provider_rating")) ?? ""
                let city = ((providerList.object(at: i) as! NSDictionary).value(forKey: "City")) ?? ""
                let state = ((providerList.object(at: i) as! NSDictionary).value(forKey: "State")) ?? ""
                let ratingAllow = ((providerList.object(at: i) as! NSDictionary).value(forKey: "RatingAllow")) ?? ""
                let credit = ((providerList.object(at: i) as! NSDictionary).value(forKey: "Credit") as? Int) ?? 0
                let providerCredit = ((providerList.object(at: i) as! NSDictionary).value(forKey: "Provider_Credit") as? Int) ?? 0
                let grade = ((providerList.object(at: i) as! NSDictionary).value(forKey: "Grade")) ?? ""
                let availableServices = ((providerList.object(at: i) as! NSDictionary).value(forKey: "available_services")) as! NSArray
                var services = ""
                if availableServices.count > 0 {
                    services = self.combinedServices(services: availableServices, key: "MainService")
                }
                let query = "INSERT INTO ProviderNearService ('Provider_id', 'Provider_name', 'Address', 'Contact_number', 'Latitude', 'Longitude', 'Icon_small_url', 'Icon_url', 'Gallery_thumbnail_image_url', 'Gallery_image_url', 'Provider_rating', 'City', 'State', 'Rating_allow', 'Credit', 'ProviderCredit', 'Available_services', 'Grade') VALUES ('\(providerId)', '\(providerName)', '\(address)', '\(mobile)', '\(lati)', '\(longi)', '\(iconSmallUrl)', '\(iconUrl)', '\(galleryThumbImgUrl)', '\(galleryImgUrl)', '\(providerRating)', '\(city)', '\(state)', '\(ratingAllow)', '\(credit)', '\(providerCredit)', '\(services)', '\(grade)')"
                
                if !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
            }
        }
        database.close()
    }
    
    func updateServiceProviderNearByData(providerId: String, distance: Float) {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return
        }
        let updateQuery = "UPDATE ProviderNearService SET DistanceMatrix = '\(distance)' WHERE Provider_id = '\(providerId)'"
        if !database.executeStatements(updateQuery) {
            print(database.lastError(), database.lastErrorMessage())
        }
        
        database.close()
    }
    
    //Insert Appointment Details
    func SaveAppointmentDetailsData(appointmentDetails: NSArray) {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return
        }
        //public void insertAppointmentDetails(GetAppointmentDetails getAppointmentDetails, String jsonObject){
        if appointmentDetails.count > 0 {
            //Delete Appointment data
            let deleteQuery = "delete from AppointmentDetails"
            if !database.executeStatements(deleteQuery) {
                print(database.lastError(), database.lastErrorMessage())
            }
            
            //Insert data
            for i in 0..<appointmentDetails.count {
                let appointmentId = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "appointment_id")) ?? ""
                let facilityName = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "facility_name")) ?? ""
                let providerName = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "provider_name")) ?? ""
                let memberName = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "member_name")) ?? ""
                let appointmentDate = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "appointment_date")) ?? ""
                let appointmentTime = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "appointment_time")) ?? ""
                let appointmentStatus = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "appointment_status")) ?? ""
                let providerAddress = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "provider_address")) ?? ""
                let mobileNo = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "MobileNo")) ?? ""
                let dateTime_milis = 0
                let dateTime = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "DateTime")) ?? ""
                let facilityId = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "FacilityId")) ?? ""
                let serviceType = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "ServiceType")) ?? ""
                let currentFlag = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "CurrentFlag")) ?? ""
                let actionFlag = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "ActionFlag") as? Int) ?? 0
                
                let relationId = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "RelationId")) ?? ""
                let emailId = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "EmailId")) ?? ""
                let planType = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "PlanType")) ?? ""
                let memberId = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "MemberId")) ?? ""
                let directAppointment = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "DirectAppointment")) ?? ""
                let canReason = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "CanReason")) ?? ""
                let providerId = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "provider_id")) ?? ""
                
                let uploadPath = ((appointmentDetails.object(at: i) as! NSDictionary).value(forKey: "ReportUploadPath")) as! NSArray
                
                var query = "INSERT INTO ProviderNearService ('appointment_id', 'facility_name', 'provider_name', 'member_name', 'appointment_date', 'appointment_time', 'appointment_status', 'provider_address', 'MobileNo', 'DateTime_milis', 'DateTime', 'FacilityId', 'ServiceType', 'CurrentFlag', 'ActionFlag', 'RelationId', 'EmailId', 'PlanType', 'MemberId', 'DirectAppointment', 'CanReason', 'provider_id') VALUES ('\(appointmentId)', '\(facilityName)', '\(providerName)', '\(memberName)', '\(appointmentDate)', '\(appointmentTime)', '\(appointmentStatus)', '\(providerAddress)', '\(mobileNo)', '\(dateTime_milis)', '\(dateTime)', '\(facilityId)', '\(serviceType)', '\(currentFlag)', '\(actionFlag)', '\(relationId)', '\(emailId)', '\(planType)', '\(memberId)', '\(directAppointment)', '\(canReason)', '\(providerId)')"

                if uploadPath.count > 0 {
                    query = "INSERT INTO ProviderNearService ('appointment_id', 'facility_name', 'provider_name', 'member_name', 'appointment_date', 'appointment_time', 'appointment_status', 'provider_address', 'MobileNo', 'DateTime_milis', 'DateTime', 'FacilityId', 'ServiceType', 'CurrentFlag', 'ActionFlag', 'RelationId', 'EmailId', 'PlanType', 'MemberId', 'DirectAppointment', 'CanReason', 'provider_id', 'ReportUploadPath') VALUES ('\(appointmentId)', '\(facilityName)', '\(providerName)', '\(memberName)', '\(appointmentDate)', '\(appointmentTime)', '\(appointmentStatus)', '\(providerAddress)', '\(mobileNo)', '\(dateTime_milis)', '\(dateTime)', '\(facilityId)', '\(serviceType)', '\(currentFlag)', '\(actionFlag)', '\(relationId)', '\(emailId)', '\(planType)', '\(memberId)', '\(directAppointment)', '\(canReason)', '\(providerId)', '\(uploadPath)')"
                }
                
                if !database.executeStatements(query) {
                    print("Failed to insert initial data into the database.")
                    print(database.lastError(), database.lastErrorMessage())
                }
            }
            
        }
        
        database.close()
    }
    
    //MARK:- Read From Database
    
    //Read User Profile Database
    func readUserProfileDatabase(key: String, table: String) -> String {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return ""
        }
        
        let query = "select * from \(table)"
        do {
            let results = try database.executeQuery(query, values: nil)
            if results.next() {
                let idStr = results.string(forColumn: key) ?? ""
                database.close()
                return idStr
            }
        } catch {
            print(error.localizedDescription)
        }
        database.close()
        return ""
    }
    
    //Get Relation member id for booking
    func getRelationMemberId(relationId: Int, relationType: String) -> String {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return ""
        }
        var query = "select MemberId from FamilyDetails Where RelationId = \(relationId)"
        if relationId == 8 || relationId == 9 || relationId == 17 {
            query = "select MemberId from FamilyDetails Where RelationId = \(relationId) and RelationType = \(relationType)"
        }
        
        
        do {
            let results = try database.executeQuery(query, values: nil)
            if results.next() {
                let idStr = results.string(forColumn: "MemberId") ?? ""
                database.close()
                return idStr
            }
        } catch {
            print(error.localizedDescription)
        }
        
        database.close()
        return ""
    }
    
    //Select all data from Provider
    func getProviderListFromDatabase() -> NSArray {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return []
        }
        var listArr =  Array<Dictionary<String, Any>>()
        let query = "select Provider_id, Provider_name, Address, Contact_number, Latitude, Longitude, Icon_small_url, Icon_url, Provider_rating, City, State, Rating_allow, Credit, Available_services, Gallery_thumbnail_image_url, Gallery_image_url, ProviderCredit from Provider"
        do {
            let results = try database.executeQuery(query, values: nil)
            
            while results.next() {
                let availableService: String = results.string(forColumn: "Available_services") ?? ""
                let listStrings = availableService.components(separatedBy: ",") as NSArray
                var subListArr =  Array<Dictionary<String, Any>>()
                for i in 0..<listStrings.count {
                    let fId = (listStrings.object(at: i) as! String)
                    let subQuery = "select FacilityId, FacilityName, FacilityType, ServiceType, isActive, isSubService, TotalAvailable, Consumed, HealthCredit, image, FacilityCode from FacilityServices Where FacilityId = '\(fId)' AND isActive = '\(true)'"
                    do {
                        let subResults = try database.executeQuery(subQuery, values: nil)
                        while subResults.next() {
                            let fId = subResults.string(forColumn: "FacilityId") ?? ""
                            let fName = subResults.string(forColumn: "FacilityName") ?? ""
                            let fType = subResults.string(forColumn: "FacilityType") ?? ""
                            let fServiceType = subResults.string(forColumn: "ServiceType") ?? ""
                            let fActive = subResults.string(forColumn: "isActive") ?? ""
                            let fSubService = subResults.string(forColumn: "isSubService") ?? ""
                            let fTotal = subResults.string(forColumn: "TotalAvailable") ?? ""
                            let fConsumed = subResults.string(forColumn: "Consumed") ?? ""
                            let fHealth = subResults.string(forColumn: "HealthCredit") ?? ""
                            let fImage = subResults.string(forColumn: "image") ?? ""
                            let fCode = subResults.string(forColumn: "FacilityCode") ?? ""
                            let subDict = ["service_id": fId,
                                           "Service_Name": fName,
                                           "FacilityType": fType,
                                           "ServiceType": fServiceType,
                                           "isActive": fActive,
                                           "isSubService": fSubService,
                                           "total_available": fTotal,
                                           "consumed": fConsumed,
                                           "health_credit": fHealth,
                                           "image": fImage,
                                           "FacilityCode": fCode,
                                           ] as [String : Any]
                            subListArr.append(subDict)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                let pId = results.string(forColumn: "Provider_id") ?? ""
                let pName = results.string(forColumn: "Provider_name") ?? ""
                let pAdress = results.string(forColumn: "Address") ?? ""
                let pNumber = results.string(forColumn: "Contact_number") ?? ""
                let pLat = results.string(forColumn: "Latitude") ?? ""
                let pLong = results.string(forColumn: "Longitude") ?? ""
                let pIconSmallUrl = results.string(forColumn: "Icon_small_url") ?? ""
                let pIconUrl = results.string(forColumn: "Icon_url") ?? ""
                let pRating = results.string(forColumn: "Provider_rating") ?? ""
                let pCity = results.string(forColumn: "City") ?? ""
                let pState = results.string(forColumn: "State") ?? ""
                let pRatingAllow = results.string(forColumn: "Rating_allow") ?? ""
                let pCredit = results.string(forColumn: "Credit") ?? ""
                let pProviderCredit = results.string(forColumn: "ProviderCredit") ?? ""
                let pGalleryThumb = results.string(forColumn: "Gallery_thumbnail_image_url") ?? ""
                let galleryImgStr: String = results.string(forColumn: "Gallery_image_url") ?? ""
                let galleryArr = galleryImgStr.components(separatedBy: ",") as NSArray
                let dict = ["provider_id": pId,
                            "provicer_name": pName,
                            "address": pAdress,
                            "contact_number": pNumber,
                            "latitude": pLat,
                            "longitude": pLong,
                            "icon_image_small_url": pIconSmallUrl,
                            "icon_image_url": pIconUrl,
                            "provider_rating": pRating,
                            "City": pCity,
                            "State": pState,
                            "RatingAllow": pRatingAllow,
                            "Credit": pCredit,
                            "Provider_Credit": pProviderCredit,
                            "gallery_thumbnail_image_url": pGalleryThumb,
                            "gallery_image_url": galleryArr,
                            "available_services": subListArr
                    ] as [String : Any]
                
                listArr.append(dict)
            }
            
            return listArr as NSArray
            
        } catch {
            print(error.localizedDescription)
        }
        
        database.close()
        return []
    }
    
    //Select all data from Service Provider Nearby
    func getHospitalListNearByData(orderBy: String, limit: Float) -> NSArray {
        let database = self.openDatabase()
        if !database.open() {
            print("Unable to open database")
            return []
        }
        var listArr =  Array<Dictionary<String, Any>>()
        var query = ""
        if orderBy == "" {
            query = "select Provider_id, Provider_name, Address, Contact_number, Latitude, Longitude, Icon_small_url, Icon_url, Provider_rating, City, State, DistanceMatrix, Rating_allow, Credit, Gallery_thumbnail_image_url, Gallery_image_url, Grade, ProviderCredit from ProviderNearService Where DistanceMatrix <= \(limit) ORDER BY Grade ASC"
        }
        else {
            query = "select Provider_id, Provider_name, Address, Contact_number, Latitude, Longitude, Icon_small_url, Icon_url, Provider_rating, City, State, DistanceMatrix, Rating_allow, Credit, Gallery_thumbnail_image_url, Gallery_image_url, Grade from ProviderNearService Where DistanceMatrix <= \(limit) ORDER BY Grade ASC, \(orderBy)"
        }
        
        do {
            let results = try database.executeQuery(query, values: nil)
            
            while results.next() {
                
                let pId = results.string(forColumn: "Provider_id") ?? ""
                let pName = results.string(forColumn: "Provider_name") ?? ""
                let pAdress = results.string(forColumn: "Address") ?? ""
                let pNumber = results.string(forColumn: "Contact_number") ?? ""
                let pLat = results.string(forColumn: "Latitude") ?? ""
                let pLong = results.string(forColumn: "Longitude") ?? ""
                let pIconSmallUrl = results.string(forColumn: "Icon_small_url") ?? ""
                let pIconUrl = results.string(forColumn: "Icon_url") ?? ""
                let pRating = results.string(forColumn: "Provider_rating") ?? ""
                let pCity = results.string(forColumn: "City") ?? ""
                let pState = results.string(forColumn: "State") ?? ""
                let pDistance = results.string(forColumn: "DistanceMatrix") ?? ""
                let pRatingAllow = results.string(forColumn: "Rating_allow") ?? ""
                let pCredit = results.string(forColumn: "Credit") ?? ""
                let pGrade = results.string(forColumn: "Grade") ?? ""
                let pProviderCredit = results.string(forColumn: "ProviderCredit") ?? ""
                let pGalleryThumb = results.string(forColumn: "Gallery_thumbnail_image_url") ?? ""
                let galleryImgStr: String = results.string(forColumn: "Gallery_image_url") ?? ""
                let galleryArr = galleryImgStr.components(separatedBy: ",") as NSArray
                
                
                let dict = ["provider_id": pId,
                            "provicer_name": pName,
                            "address": pAdress,
                            "contact_number": pNumber,
                            "latitude": pLat,
                            "longitude": pLong,
                            "icon_image_small_url": pIconSmallUrl,
                            "icon_image_url": pIconUrl,
                            "provider_rating": pRating,
                            "City": pCity,
                            "State": pState,
                            "Distance": pDistance,
                            "RatingAllow": pRatingAllow,
                            "Credit": pCredit,
                            "Grade": pGrade,
                            "Provider_Credit": pProviderCredit,
                            "gallery_thumbnail_image_url": pGalleryThumb,
                            "gallery_image_url": galleryArr
                    ] as [String : Any]
                
                listArr.append(dict)
            }
            
            return listArr as NSArray
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        database.close()
        return []
    }
    
}

