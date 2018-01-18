//
//  HAProviderListVC.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 05/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMaps

class HAProviderListVC: UIViewController,MFMailComposeViewControllerDelegate{
    
    var facilityCode = ""
    var latStr = ""
    var longStr = ""
    var creditStr = ""
    var rangeStr = "10"
    var ratingType = "Provider_rating DESC"
    var titleStr = ""
    var cityNameStr = ""
    var dataArray: NSMutableArray = []
    var copyofdataArray : NSMutableArray = []
    var available = ""
    var consumed = ""
    var leading:CGFloat = 0.0
    
    @IBOutlet var cityBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet var countLbl: UILabel!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var cityButton: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var list_tblview: UITableView!
    @IBOutlet var search_txtfld: UITextField!
    @IBOutlet var trailing_searchtxtfld_constraint: NSLayoutConstraint!
    @IBOutlet var leading_searchtxtfld_constraint: NSLayoutConstraint!
    var SOS_popup: HAProviderList_Sos_popup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.setTitle(titleStr.uppercased(), for: .normal)
        cityButton.setTitle("\(cityNameStr)", for: UIControlState.normal)
        var width = (cityNameStr.width(withConstraintedHeight: 22, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light))) + 30
        if width > self.view.frame.size.width - 120 {
            width = self.view.frame.size.width - 120
        }
        cityBtnWidthConstraint.constant = width
        cityButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cityButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cityButton.titleLabel?.textAlignment = NSTextAlignment.left
        cityButton.titleLabel?.lineBreakMode = .byTruncatingTail
        cityButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
        cityButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        cityButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        cityButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.view.layoutIfNeeded()
        
        list_tblview.delegate = self
        list_tblview.dataSource = self
        list_tblview.estimatedRowHeight = 200
        list_tblview.rowHeight = UITableViewAutomaticDimension
        leading = leading_searchtxtfld_constraint.constant
        
        list_tblview.tableFooterView = UIView.init()
        self.getPackageDetail()
        
        self.backBtn.setTitle(titleStr, for: .normal)
        self.countLbl.text = consumed + "/" + available
        
        SOS_popup = Bundle.main.loadNibNamed("HAProviderList_Sos_popup", owner: self, options: nil)?.first as? HAProviderList_Sos_popup
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func tapOnFilterBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HAFilterViewController") as! HAFilterViewController
        vc.selectedRating = self.ratingType
        vc.distance = Int(self.rangeStr)!
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func tapOnSearchBtn(_ sender: Any) {
        
        
        
        if searchBtn.tag == 0{
            
            searchBtn.tag = 1
            search_txtfld.isHidden = false
            self.search_txtfld.layer.cornerRadius = self.search_txtfld.frame.width/40
            self.search_txtfld.layer.borderWidth = 1
            self.search_txtfld.layer.borderColor = UIColor(red: 96/255, green: 167/255, blue: 165/255, alpha: 1.0).cgColor
            self.copyofdataArray = self.dataArray.mutableCopy() as! NSMutableArray
            UIView.animate(withDuration: 0.2, animations: {
                
                self.leading_searchtxtfld_constraint.constant = 10
                self.view.layoutIfNeeded()
                
            }, completion: { (result) in
                self.searchBtn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
                self.cityButton.isHidden = true
                self.search_txtfld.setLeftPaddingPoints(10)
                self.search_txtfld.setRightPaddingPoints(self.searchBtn.frame.width-10)
            })
            
        }else{
            
            searchBtn.tag = 0
            search_txtfld.text = ""
            self.dataArray = self.copyofdataArray.mutableCopy() as! NSMutableArray
            self.list_tblview.reloadData()
            search_txtfld.resignFirstResponder()
            self.copyofdataArray.removeAllObjects()
            UIView.animate(withDuration: 0.2, animations: {
                
                self.leading_searchtxtfld_constraint.constant = self.leading
                self.view.layoutIfNeeded()
                
            }, completion: { (result) in
                
                self.search_txtfld.isHidden = true
                self.cityButton.isHidden = false
                self.searchBtn.setImage(#imageLiteral(resourceName: "bookingSearch"), for: .normal)
                
            })
            
        }
    }
    @IBAction func tapOnCityBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HASearchCityViewController") as! HASearchCityViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapOnBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func type_searchTextfld(_ sender: Any) {
        
        searchingInData()
        
    }
    
    //MARK:- Searching
    
    func searchingInData(){
        
        if search_txtfld.text == ""{
            
            dataArray = copyofdataArray.mutableCopy() as! NSMutableArray
            list_tblview.reloadData()
            
        }else{
            
            dataArray.removeAllObjects()
            search()
            
        }
    }
    
    func search(){
        
        for i in 0..<copyofdataArray.count{
            
            if (String(describing: (copyofdataArray.object(at: i) as! NSDictionary).value(forKey: "provicer_name")!).uppercased()).contains(((search_txtfld.text!).uppercased())) == true{
                
                dataArray.add((copyofdataArray.object(at: i) as! NSDictionary))
                
            }
            
        }
        list_tblview.reloadData()
    }
    
    func getPackageDetail() {
        if !isConnectedToNetwork() {
            self.showOkAlert("Oops! no internet connection.")
        
        }else{
            
            let userDetail = ["user_id": HALoggedInUser.shared.getUserId(),"FacilityId": facilityCode,"latitude": latStr,"longitude": longStr,"Range": rangeStr,"Credit": creditStr] as [String : Any]
            let params = ["user_details": userDetail,] as [String : Any]
            
            HASwiftLoader.show(animated: true)
            
            Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "getServiceProviderByService", params: params as! [String: NSObject]){ (receivedData) in
                
                print(receivedData)
                HASwiftLoader.hide()
                
                if Singleton.shared.connection.responceCode == 1{
                    
                    if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                        
                        if let arr = receivedData.value(forKey: "service_provider_list") {
                            if arr is [Dictionary<String, Any>] {
                                //self.dataArray = (receivedData.value(forKey: "service_provider_list") as! NSArray).mutableCopy() as! NSMutableArray
                                let tmpArr = receivedData.value(forKey: "service_provider_list") as! NSArray
                                HADatabase.shared.SaveServiceProviderNearByData(providerList: tmpArr)
                                self.getDistanceUsingGoogleMap(list: tmpArr)
                                //self.list_tblview.reloadData()
                            }else{
                                
                                self.showOkAlertWithHandler("Oops! No service providers found.", handler: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }
                        }
                    }else{
                        
                        self.showOkAlert(String(describing: receivedData.value(forKey: "message")!))
                    }
                    
                }else{
                    
                    self.showOkAlert(String(describing: receivedData.value(forKey: "Error")!))
                }
            }
        }
    }
    
    func getDistanceUsingGoogleMap(list: NSArray) {
        
        let sourceLocManager: CLLocation = CLLocation(latitude: Double(latStr)!, longitude: Double(longStr)!)
        
        for i in 0..<list.count {
            if let dict = list[i] as? Dictionary<String, Any> {
                var lati: Double = 0
                var longi: Double = 0
                var providerId = ""
                if let lat = dict["latitude"] as? String {
                    lati = Double(lat) ?? 0
                }
                if let long = dict["longitude"] as? String {
                    longi = Double(long) ?? 0
                }
                if let pId = dict["provider_id"] as? String {
                    providerId = pId
                }
                
                if lati != 0 {
                    let destinationLocManager: CLLocation = CLLocation(latitude: lati, longitude: longi)
                    var dist: Float = Float((sourceLocManager.distance(from:destinationLocManager))/1000)
                    let disStr = String(format: "%.1f", dist)
                    dist = Float(disStr) ?? 0.0
                    HADatabase.shared.updateServiceProviderNearByData(providerId: providerId, distance: dist)
                }
            }
        }
        let hospitalList = HADatabase.shared.getHospitalListNearByData(orderBy: self.ratingType, limit: Float(self.rangeStr)!)
        if hospitalList.count > 0 {
            self.dataArray = hospitalList.mutableCopy() as! NSMutableArray
            self.list_tblview.reloadData()
        }
    }
}
extension HAProviderListVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = list_tblview.dequeueReusableCell(withIdentifier: "HAProviderListTableViewCell", for: indexPath) as! HAProviderListTableViewCell
        
        cell.name_lbl.text = String(describing: (dataArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "provicer_name")!)
        cell.address_lbl.text = String(describing: (dataArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "address")!)
        cell.ratingValue_lbl.text = String(describing: (dataArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "provider_rating")!)
        if String(describing: (dataArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Distance")!)
            != "<null>" {
            let dist = String(describing: (dataArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Distance")!)
            cell.distance_lbl.text = "\(dist) km"
            
        }else{
            cell.distance_lbl.text = "0 km"
        }
        cell.price_lbl.text = String(describing: (dataArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Credit")!)
        cell.sos_btn.tag = indexPath.row
        cell.sos_btn.addTarget(self, action: #selector(handle_SOS), for: .touchUpInside)
        cell.book_btn.addTarget(self, action: #selector(booknow), for: .touchUpInside)
        cell.book_btn.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HABookingViewController") as! HABookingViewController
        vc.data = (dataArray.object(at: indexPath.row) as! NSDictionary)
        vc.consumed = consumed
        vc.available = self.available
        vc.serviceName = titleStr
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
 
}


extension HAProviderListVC : HASearchCityDelegate{
    func fetchUserLocation() {
        
    }
    
    func refreshDataOnMap(_ lat: String, lot: String, addr: String) {
        self.latStr = lat
        self.longStr = lot
        self.cityNameStr = addr
        self.cityButton.setTitle(cityNameStr, for: .normal)
        var width = (cityNameStr.width(withConstraintedHeight: 22, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light))) + 30
        if width > self.view.frame.size.width - 120 {
            width = self.view.frame.size.width - 120
        }
        cityBtnWidthConstraint.constant = width
        self.getPackageDetail()
    }
    
}

extension HAProviderListVC : filterValuesDelegates{
    
    func valuesforfilter(ratingString: String, Distance: Int) {
        
        self.ratingType = ratingString
        if rangeStr != String(describing: Distance){
            
            self.rangeStr = String(describing: Distance)
            self.getPackageDetail()
        }
        else {
            let hospitalList = HADatabase.shared.getHospitalListNearByData(orderBy: self.ratingType, limit: Float(self.rangeStr)!)
            
            if hospitalList.count > 0 {
                self.dataArray = hospitalList.mutableCopy() as! NSMutableArray
                self.list_tblview.reloadData()
            }
        }
        
    }
    
    @objc func booknow(sender : UIButton){
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HABookingViewController") as! HABookingViewController
        vc.data = (dataArray.object(at: sender.tag) as! NSDictionary)
        vc.consumed = consumed
        vc.available = self.available
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func handle_SOS(sender: UIButton){
        
        SOS_popup.frame = self.view.frame
        SOS_popup.calling_btn.addTarget(self, action: #selector(tapedCall_btn), for: .touchUpInside)
        SOS_popup.calling_btn.tag = sender.tag
        SOS_popup.messaging_btn.addTarget(self, action: #selector(tapedMessage_btn), for: .touchUpInside)
        SOS_popup.messaging_btn.tag = sender.tag
        SOS_popup.close_btn.addTarget(self, action: #selector(tapClose_btn), for: .touchUpInside)
        
        SOS_popup.calling_view.layer.masksToBounds = true
        SOS_popup.calling_view.layer.cornerRadius = SOS_popup.calling_view.frame.width/2
        SOS_popup.calling_view.layer.borderWidth = 1
        SOS_popup.calling_view.layer.borderColor = UIColor.darkGray.cgColor
        
        SOS_popup.messaging_view.layer.masksToBounds = true
        SOS_popup.messaging_view.layer.cornerRadius = SOS_popup.messaging_view.frame.width/2
        SOS_popup.messaging_view.layer.borderWidth = 1
        SOS_popup.messaging_view.layer.borderColor = UIColor.darkGray.cgColor
        
        SOS_popup.popOptions_view.layer.masksToBounds = true
        SOS_popup.popOptions_view.layer.cornerRadius = SOS_popup.frame.width/40
        
        self.view.addSubview(self.SOS_popup)
    }
    
    @objc func tapedCall_btn(sender: UIButton){
  
        if let number = (dataArray.object(at: sender.tag) as! NSDictionary).value(forKey: "contact_number") as? Int{
            
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url){
                
                if #available(iOS 10.0, *) {
                    
                    UIApplication.shared.open(url)
                    
                } else {
                    
                    UIApplication.shared.openURL(url)
                    
                }
            }
        }else{
            
            return
        }
    }
    
    @objc func tapedMessage_btn(){
         
        /*let activityViewController = UIActivityViewController(
            activityItems: [],
            applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.postToWeibo, UIActivityType.message, UIActivityType.print, UIActivityType.copyToPasteboard,UIActivityType.assignToContact,UIActivityType.saveToCameraRoll,UIActivityType.addToReadingList, UIActivityType.postToFlickr, UIActivityType.postToVimeo,UIActivityType.postToTencentWeibo,UIActivityType.airDrop]

       
        present(activityViewController, animated: true, completion: nil)*/
        
  
        if let url = URL(string: "mailto://hello@healthassure.in"), UIApplication.shared.canOpenURL(url){
            
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(url)
                
            } else {
                
                UIApplication.shared.openURL(url)
                
            }
        }
        
    }
    
   
    
    
    
    @objc func tapClose_btn(){
        
        self.SOS_popup.removeFromSuperview()
    }
}
