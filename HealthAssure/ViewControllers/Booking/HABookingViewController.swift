//
//  HABookingViewController.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/15/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit
import MapKit

class HABookingViewController: UIViewController,UIScrollViewDelegate {

    //MARK: Outlets
    @IBOutlet var navigation_view: UIView!
    @IBOutlet var back_btn: UIButton!
    @IBOutlet var cancel_btn: UIButton!
    @IBOutlet var scroll_view: UIScrollView!
    @IBOutlet var container_view: UIView!
    
    @IBOutlet var pager_scroll_view: UIScrollView!
    @IBOutlet var page_control: UIPageControl!
    @IBOutlet var location_view: UIView!
    @IBOutlet var location_btn: UIButton!
    
    @IBOutlet var hospitalDetail_view: UIView!
    @IBOutlet var hospital_logo: UIImageView!
    @IBOutlet var hospitalName_lbl: UILabel!
    @IBOutlet var hospitalAdress_lbl: UILabel!
    @IBOutlet var location_img: UIImageView!
    @IBOutlet var phone_img: UIImageView!
    @IBOutlet var contact_number: UILabel!
    @IBOutlet var rating_lbl: UILabel!
    @IBOutlet var ratingValue_lbl: UILabel!
    @IBOutlet var distance_icon: UIImageView!
    @IBOutlet var distance_lbl: UILabel!
    @IBOutlet var rupee_icon: UIImageView!
    @IBOutlet var price_lbl: UILabel!
    
    @IBOutlet var service_img: UIImageView!
    @IBOutlet var topOfService_image: NSLayoutConstraint!
    @IBOutlet var service_name: UILabel!
    @IBOutlet var count_lbl: UILabel!
    
    @IBOutlet var patient_selection: UIView!
    @IBOutlet var patient_lbl: UILabel!
    @IBOutlet var dropdown_icon: UIImageView!
    @IBOutlet var patient_btn: UIButton!
    
    @IBOutlet var patientName_txtfld: UITextField!
    @IBOutlet var seperator1_view: UIView!
    
    @IBOutlet var topOfDate_view: NSLayoutConstraint!
    @IBOutlet var date_view: UIView!
    @IBOutlet var selectdate_lbl: UILabel!
    @IBOutlet var date_lbl: UILabel!
    @IBOutlet var dateSeperator_view: UIView!
    @IBOutlet var date_img: UIImageView!
    
    @IBOutlet var time_view: UIView!
    @IBOutlet var selectTime_lbl: UILabel!
    @IBOutlet var time_lbl: UILabel!
    @IBOutlet var timeSeperator_view: UIView!
    @IBOutlet var clock_icon: UIImageView!
    
    @IBOutlet var topPromocode_btn: NSLayoutConstraint!
    @IBOutlet var promocode_btn: UIButton!
    
    @IBOutlet var topOfRequestAppointment_view: NSLayoutConstraint!
    @IBOutlet var requestAppointment_view: UIView!
    @IBOutlet var requestAppointment_lbl: UILabel!
    @IBOutlet var requestAppointment_btn: UIButton!
    
    @IBOutlet var topOftandc_view: NSLayoutConstraint!
    @IBOutlet var termsandCondition_view: UIView!
    @IBOutlet var check_box_btn: UIButton!
    @IBOutlet var iagree_lbl: UILabel!
    @IBOutlet var tandc_lbl: UILabel!
    
    @IBOutlet var tableViewContainer_view: UIView!
    @IBOutlet var table_view: UITableView!
    @IBOutlet var footer_view: UIView!
    @IBOutlet var add_btn: UIButton!
    @IBOutlet var add_lbl: UILabel!
    @IBOutlet var height_tableview: NSLayoutConstraint!
    
    var cancelPopup: HABookingCancelPopup!
    var requestappointment_popup: HAbookingAppointmentPopup!
    var applyPromocode_popup: HAPromoCode_popup!
    var pickdate: HADatePicker!
    var isEdit = false
    
    var mobileNumber_txtfld: UITextField!
    //MARK:- Variables
    let images:NSMutableArray = []
    var data: NSDictionary = [:]
    var available = ""
    var consumed = ""
    var serviceName = ""
    //MARK:- Default Actions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (data.value(forKey: "FacilityCode") as? String) != nil{
            
            self.consumed = String(describing: data.value(forKey: "consumed") as? Int ?? 0)
            self.available = String(describing: data.value(forKey: "total_available") as? Int ?? 0)
            self.serviceName = String(describing: data.value(forKey: "Service_Name") as? String
                ?? "")
            handleTDRandNTServices()
        }else{
      
            assignData()
            
        }
        loadingAction()
        self.count_lbl.text = consumed + "/" + available
        self.service_name.text = serviceName
        cancelPopup = Bundle.main.loadNibNamed("HABookingCancelPopup", owner: self, options: nil)?.first as? HABookingCancelPopup
        requestappointment_popup = Bundle.main.loadNibNamed("HAbookingAppointmentPopup", owner: self, options: nil)?.first as? HAbookingAppointmentPopup
        applyPromocode_popup = Bundle.main.loadNibNamed("HAPromoCode_popup", owner: self, options: nil)?.first as? HAPromoCode_popup
        pickdate = Bundle.main.loadNibNamed("HADatePicker", owner: self, options: nil)?.first as? HADatePicker
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (data.value(forKey: "FacilityCode") as? String) != nil{
            
            self.scroll_view.contentSize = CGSize(width: self.view.frame.width, height: 812-self.navigation_view.frame.height-15)
            
        }else{
            
            self.scroll_view.contentSize = CGSize(width: self.view.frame.width, height: 812-self.navigation_view.frame.height)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Actions
    @IBAction func tapBack_btn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapCancel_btn(_ sender: UIButton) {
        
        cancelPopup.frame = self.view.frame
        
        cancelPopup.close_btn.addTarget(self, action: #selector(closepopup), for: .touchUpInside)
        cancelPopup.no_btn.addTarget(self, action: #selector(closepopup), for: .touchUpInside)
        cancelPopup.yes_btn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        
        cancelPopup.layer.masksToBounds = true
        cancelPopup.layer.cornerRadius = cancelPopup.frame.width/40
        
        self.view.addSubview(cancelPopup)
    }
    @IBAction func tapPatient_btn(_ sender: UIButton) {
        
        if patient_btn.tag == 0{
            patient_btn.tag = 1
            self.tableViewContainer_view.isHidden = false
            height_tableview.constant = 0
            tableViewContainer_view.layer.masksToBounds = false
            tableViewContainer_view.layer.shadowColor = UIColor.black.cgColor
            tableViewContainer_view.layer.shadowOpacity = 0.8
            tableViewContainer_view.layer.shadowOffset = CGSize.zero
            tableViewContainer_view.layer.shadowRadius = 4.0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.height_tableview.constant = 130
                self.view.layoutIfNeeded()
            }, completion: { (result) in
                
                
            })
        }else{
            patient_btn.tag = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.height_tableview.constant = 0
                self.view.layoutIfNeeded()
                
            }, completion: { (result) in
                
                self.tableViewContainer_view.isHidden = true
            })
            
        }
        
    }
    @IBAction func tapPromocode_btn(_ sender: UIButton) {
        
        applyPromocode_popup.frame = self.view.frame
        applyPromocode_popup.close_btn.addTarget(self, action: #selector(closepopup), for: .touchUpInside)
        applyPromocode_popup.apply_btn.addTarget(self, action: #selector(applyPromocode), for: .touchUpInside)
        self.view.addSubview(applyPromocode_popup)
        
    }
    @IBAction func tapRequestAppointment_btn(_ sender: UIButton) {
        
        if !isConnectedToNetwork() {
            self.showOkAlert("Oops! no internet connection.")
            
        }else{
            var relationId = HALoggedInUser.shared.getUserFamilyRelationId()
            if relationId.isEmpty {
                relationId = "0"
            }
            let relId: Int = Int(relationId)!
            var memberId = ""
            if self.patient_lbl.text == "Self" {
                memberId = HALoggedInUser.shared.getUserMemberId()
            }
            else {
               memberId = HADatabase.shared.getRelationMemberId(relationId: relId, relationType: "Son")
                if memberId.isEmpty {
                    memberId = "0"
                }
            }
            let userDetail = ["UserLoginId": HALoggedInUser.shared.getUserId(), "Flag": isEdit ? "Update" : "Insert", "UserName": HALoggedInUser.shared.getUserName(), "MemberId": memberId, "FacilityId": "", "AppointmentDate": date_lbl.text!, "AppointmentTime": time_lbl.text!, "AppointmentId": isEdit ? 0 : 1, "ProviderId": data["provider_id"] ?? "", "Area": "", "Address1": data["address"] ?? "", "DoctorId": "1", "SlotId": "9", "MobileNo": "", "PremiumFlag": "N", "RelationId": memberId, "Email": HALoggedInUser.shared.getUserEmail(), "BuyFlag": "N", "IsService": "N", "ProductOfferId": "0"] as [String : Any]
            
            let params = ["details": userDetail,] as [String : Any]
            
            HASwiftLoader.show(animated: true)
            
            Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "bookAppointment", params: params as! [String: NSObject]){ (receivedData) in
                
                print(receivedData)
                HASwiftLoader.hide()
                
                if Singleton.shared.connection.responceCode == 1{
                    
                    if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                        
                        self.showSuccessAlert()
                    }else{
                        
                        self.showOkAlert(String(describing: receivedData.value(forKey: "message")!))
                    }
                    
                }else{
                    
                    self.showOkAlert(String(describing: receivedData.value(forKey: "Error")!))
                }
            }
        }
        
    }
    
    func showSuccessAlert() {
        requestappointment_popup.frame = self.view.frame
        requestappointment_popup.ok_btn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        requestappointment_popup.icon_img.layer.masksToBounds = true
        requestappointment_popup.icon_img.layer.cornerRadius = requestappointment_popup.icon_img.frame.width/2
        requestappointment_popup.icon_img.layer.borderWidth = 1
        requestappointment_popup.icon_img.layer.borderColor = UIColor.gray.cgColor
        
        requestappointment_popup.layer.cornerRadius = requestappointment_popup.frame.width/40
        requestappointment_popup.layer.masksToBounds = true
        
        self.view.addSubview(requestappointment_popup)
    }
    
    @IBAction func tapCheckbox_btn(_ sender: UIButton) {
        
        if check_box_btn.tag == 0{
            check_box_btn.tag = 1
            check_box_btn.backgroundColor =  UIColor(red: 122/255, green: 202/255, blue: 189/255, alpha: 1.0)
            check_box_btn.layer.borderColor = UIColor.white.cgColor
            check_box_btn.layer.borderWidth = 1
            
        }else{
            check_box_btn.tag = 0
            check_box_btn.backgroundColor = UIColor.white
            check_box_btn.layer.borderColor = UIColor.lightGray.cgColor
            check_box_btn.layer.borderWidth = 1
        }
        
    }
    
    @IBAction func tapLocation_btn(_ sender: UIButton) {
        
        let latitude:CLLocationDegrees = Double(String(describing: data.value(forKey: "latitude")!)) ?? 28.669156500000000
        let longitude: CLLocationDegrees = Double(String(describing: data.value(forKey: "longitude")!)) ?? 77.453757799999900
        
        let regiondistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude,longitude)
        let regionspan = MKCoordinateRegionMakeWithDistance(coordinates, regiondistance, regiondistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionspan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionspan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapitem = MKMapItem(placemark: placemark)
        mapitem.name = String(describing: data.value(forKey: "provicer_name")!)
        
        mapitem.openInMaps(launchOptions: options)
        
    }
    
    
    //MARK:- DD's
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pagenumber = round(scrollView.contentOffset.x / scrollView.frame.width)
        page_control.currentPage = Int(pagenumber)
        
    }
    
    //MARK:- Functions
    func loadingAction(){
        self.location_view.layer.masksToBounds = true
        self.location_view.layer.cornerRadius = self.location_view.frame.width/20
        self.location_view.addShadow()
        
        service_img.layer.cornerRadius = service_img.frame.width/2
        service_img.layer.masksToBounds = true
        service_img.layer.borderWidth = 1
        service_img.layer.borderColor = UIColor.darkGray.cgColor
        
        self.patient_selection.layer.borderWidth = 1
        self.patient_selection.layer.borderColor = UIColor.darkGray.cgColor
        
        self.check_box_btn.layer.borderWidth = 1
        self.check_box_btn.layer.borderColor = UIColor.lightGray.cgColor
        self.check_box_btn.layer.cornerRadius = self.check_box_btn.frame.width/12
        self.check_box_btn.layer.masksToBounds = true
        
        self.promocode_btn.layer.borderWidth = 1
        self.promocode_btn.layer.borderColor = UIColor(red: 122/255, green: 202/255, blue: 189/255, alpha: 1.0).cgColor
        self.promocode_btn.layer.cornerRadius = self.promocode_btn.frame.width/30
        self.promocode_btn.layer.masksToBounds = true
        
        self.pager_scroll_view.delegate = self
        self.pager_scroll_view.isPagingEnabled = true
        
        if let firsturlstring = self.data.value(forKey: "gallery_thumbnail_image_url") as? String{
            
            self.images.add(firsturlstring.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\\", with: "/"))
        }
        
        if let secondurlstring = self.data.value(forKey: "icon_image_url") as? String{
            
            self.images.add(secondurlstring.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\\", with: "/"))
        }
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        for i in 0..<images.count{
            
            frame.origin.x = self.pager_scroll_view.frame.width * CGFloat(i)
            frame.size = self.pager_scroll_view.frame.size
            
            let imageview = UIImageView(frame: frame)
            imageview.sd_setImage(with: URL(string: String(describing: images.object(at: i))), placeholderImage: #imageLiteral(resourceName: "hospital_large"), options: [], completed: nil)
            self.pager_scroll_view.addSubview(imageview)
        }
        self.pager_scroll_view.contentSize.width = self.pager_scroll_view.frame.width * CGFloat(images.count)
        
        page_control.addTarget(self, action: #selector(pagerControllWorking), for: .valueChanged)
        page_control.numberOfPages = images.count
        page_control.currentPage = min(0, images.count)
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapfooter))
        let TimeSlot_tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapTimeSlot_view))
        let dateSlot_tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapDateSlot_view))
        time_view.addGestureRecognizer(TimeSlot_tapgesture)
        date_view.addGestureRecognizer(dateSlot_tapgesture)
        self.footer_view.addGestureRecognizer(tapgesture)
        
        self.table_view.delegate = self
        self.table_view.dataSource = self
        self.add_btn.layer.masksToBounds = true
        self.add_btn.layer.cornerRadius = self.add_btn.frame.width/2
        self.add_btn.layer.borderColor = UIColor.black.cgColor
        self.add_btn.layer.borderWidth = 1
        
    }
    func assignData(){
        
        self.hospitalName_lbl.text = String(describing: self.data.value(forKey: "provicer_name")!)
        self.hospitalAdress_lbl.text = String(describing: self.data.value(forKey: "address")!)
        
        if let contactnumber = self.data.value(forKey: "contact_number") as? Int{
            
            self.contact_number.text = String(describing: contactnumber)
            
        }else{
            
            self.contact_number.text = "NA"
        }
        self.ratingValue_lbl.text = String(describing: self.data.value(forKey: "provider_rating")!)
        self.price_lbl.text = String(describing: self.data.value(forKey: "Credit")!)
        
        if let distance = self.data.value(forKey: "Distance") as? Int{
            
            self.distance_lbl.text = String(describing: distance)
        }else{
            self.distance_lbl.text = "0 km"
        }
        
        let urlstring = Constant.imageBaseUrl + (String(describing: self.data.value(forKey: "icon_image_small_url")!).replacingOccurrences(of: " ", with: "%20")).replacingOccurrences(of: "\\", with: "/")
        
        self.hospital_logo.sd_setImage(with: URL(string: urlstring), placeholderImage: #imageLiteral(resourceName: "Ha App"), options: [], completed: nil)
        
        
    }
    
    func handleTDRandNTServices(){
        
        self.page_control.isHidden = true
        self.location_view.isHidden = true
        self.hospitalDetail_view.isHidden = true
        
        self.topOfService_image.constant = -(self.hospitalDetail_view.frame.height-30)
        
        self.mobileNumber_txtfld = UITextField(frame: CGRect(x: 15, y: (self.seperator1_view.frame.origin.y+45)-hospitalDetail_view.frame.height, width: self.patientName_txtfld.frame.width, height: 30))
        self.mobileNumber_txtfld.placeholder = "Mobile Number"
        self.mobileNumber_txtfld.font = UIFont(name: "System", size: 14.0)
        topOfDate_view.constant = topOfDate_view.constant + 65
        
        let seperator = UIView(frame: CGRect(x: mobileNumber_txtfld.frame.origin.x, y: mobileNumber_txtfld.frame.origin.y + mobileNumber_txtfld.frame.height+1, width: mobileNumber_txtfld.frame.width, height: 1))
        seperator.backgroundColor = UIColor(red: 148/255, green: 161/255, blue: 184/255, alpha: 1.0)
        
        
        
        self.container_view.insertSubview(self.mobileNumber_txtfld, at: 0)
        self.container_view.insertSubview(seperator, at: 1)
        
        let image = UIImageView(frame: self.pager_scroll_view.frame)
        image.image = #imageLiteral(resourceName: "hospital_large")
        self.pager_scroll_view.addSubview(image)
        
        let fragment = (self.hospitalDetail_view.frame.height-80)/3
        topOftandc_view.constant = topOftandc_view.constant + fragment
        topPromocode_btn.constant = topPromocode_btn.constant + fragment
        topOfRequestAppointment_view.constant = topOfRequestAppointment_view.constant + fragment
        
    }
    
    //MARK:- Targeted Functions
    @objc func pagerControllWorking(sender: UIPageControl){
        
        let x = CGFloat(sender.currentPage) * pager_scroll_view.frame.width
        pager_scroll_view.setContentOffset(CGPoint(x: x,y: 0), animated: true)
        
    }
    
    @objc func tapfooter(){
        
        
    }
    
    @objc func tapTimeSlot_view(){
        
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HAAviailibityViewController") as! HAAviailibityViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func closepopup(){
        
        if view.subviews.contains(cancelPopup){
            cancelPopup.removeFromSuperview()
        }
        
        if view.subviews.contains(applyPromocode_popup){
            applyPromocode_popup.removeFromSuperview()
        }
    }
    
    @objc func popViewController(){
        
        if view.subviews.contains(cancelPopup){
            cancelPopup.removeFromSuperview()
        }
        if view.subviews.contains(requestappointment_popup){
            requestappointment_popup.removeFromSuperview()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func applyPromocode(){
        
        
    }
    //MARK:- Webservices
}

//MARK:- Extensions

extension HABookingViewController: UITableViewDelegate,UITableViewDataSource,timeChoosedDelegate{
    func timeSlotSelected(time: String) {
        self.time_lbl.text = time
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "membersTableViewCell", for: indexPath) as! membersTableViewCell
        
        if indexPath.row == 0{
            
            cell.relation_lbl.text = "Self"
            
        }else{
            
            cell.relation_lbl.text = "Cousin"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
            self.patient_lbl.text = "Self"
        }else{
            
            self.patient_lbl.text = "Cousin"
        }
        self.tableViewContainer_view.isHidden = true
    }
    
}
