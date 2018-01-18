//
//  HALoggedInUser.swift
//  HealthAssure
//
//  Created by Mohd Aslam on 13/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HALoggedInUser: NSObject {
    static let shared = HALoggedInUser()
    
    func getUserId() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "UserLoginId", table: "UserProfile")
        return userId
    }
    
    func getUserName() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "FirstName", table: "UserProfile")
        return userId
    }
    
    func getUserEmail() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "UserName", table: "UserProfile")
        return userId
    }
    
    func getUserMobile() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "MobileNumber", table: "UserProfile")
        return userId
    }
    
    func getUserMemberId() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "member_id", table: "UserProfile")
        return userId
    }
    
    func getUserProfileImage() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "ProfileImage", table: "UserProfile")
        return userId
    }
    
    func getUserGender() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "Gender", table: "UserProfile")
        return userId
    }
    
    func getUserStatus() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "Status", table: "UserProfile")
        return userId
    }
    
    func getUserType() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "UserTypeId", table: "UserProfile")
        return userId
    }
    
    func getUserRoll() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "UserRoleId", table: "UserProfile")
        return userId
    }
    
    func getUserFamilyRelationId() -> String {
        let userId = HADatabase.shared.readUserProfileDatabase(key: "RelationId", table: "FamilyDetails")
        return String(userId)
    }
}
