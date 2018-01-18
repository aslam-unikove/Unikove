//
//  HAHomeViewController.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 02/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage

class HAHomeViewController: UIViewController, HASearchCityDelegate {

    @IBOutlet var homeCollectionView: UICollectionView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var topView: UIView!
    @IBOutlet var expandCollaspeButton: UIButton!
    
    @IBOutlet var rightArrowBtn: UIButton!
    @IBOutlet var bottomScrollView: UIScrollView!
    @IBOutlet var leftArrowBtn: UIButton!
    var locationManager = CLLocationManager()
    private var myToolbar: UIToolbar!
    var hospitalDetail_popup: HA_HospitalDetail_popup!
    var servicesAvailable_popup: HAHome_Services_popup!
    var ServicesAvailable_data : NSDictionary = [:]
    var serviceselected = "SC"
    
    @IBOutlet var recenter_view: UIView!
    @IBOutlet var recenter_btn: UIButton!
    
    var specialistController = SpecialistConsultationVC()
    var latStr = ""
    var longStr = ""
    var buyFlag = "N"
    var planType = "N"
    var creditStr = ""
    var currentlatitude = 28.5355
    var currentLongitude = 77.3910
    
    
    var serviceDetailArr = Array<Dictionary<String, Any>>()
    var serviceProviderListArr = Array<Dictionary<String, Any>>()
    var isExpanded = false
    var titleButton = UIButton.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.navigationController?.isNavigationBarHidden = false
        self.addNavigationBarButtons()
        
        topView.layer.masksToBounds = false
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.2
        topView.layer.shadowOffset = CGSize(width: 0, height: 6)
        topView.layer.shadowRadius = 1.0
        
        recenter_view.layer.masksToBounds = false
        recenter_view.layer.cornerRadius = recenter_view.frame.width/2
        recenter_view.layer.shadowColor = UIColor.darkGray.cgColor
        recenter_view.layer.shadowOpacity = 0.4
        recenter_view.layer.shadowOffset = CGSize.zero
        recenter_view.layer.shadowRadius = 6.0
        hospitalDetail_popup = Bundle.main.loadNibNamed("HA_HospitalDetail_popup", owner: self, options: nil)?.first as? HA_HospitalDetail_popup
        servicesAvailable_popup = Bundle.main.loadNibNamed("HAHome_Services_popup", owner: self, options: nil)?.first as? HAHome_Services_popup
        
        self.addImagesInScrollView()
        self.fetchUserLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func addNavigationBarButtons() {
        let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 74))
        statusbarView.backgroundColor = UIColor.getRGBColor(20, g: 64, b: 126)
        self.view.addSubview(statusbarView)
        
        myToolbar = UIToolbar(frame: CGRect(x:0 , y: 30, width: self.view.frame.size.width, height: 44))
        myToolbar.barStyle = .default
        //myToolbar.tintColor =  UIColor.white
        myToolbar.barTintColor = statusbarView.backgroundColor
        myToolbar.isTranslucent = false
        myToolbar.clipsToBounds = true
        statusbarView.addSubview(myToolbar)
        
        let flexibleSpaceLeft: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let menuButton: UIBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "menuIcon"), style: .plain, target: self.slideMenuController, action: #selector(toggleLeft))
        menuButton.tintColor = UIColor.white
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        
        
        let flexibleSpaceRight: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        flexibleSpaceRight.width = 10
        let updateButton: UIBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "homeNotification"), style: .plain, target: self, action: #selector(tapOnUpdateButton))
        updateButton.tintColor = UIColor.white
        
        myToolbar.items = [menuButton, flexibleSpaceLeft, flexibleSpaceRight, updateButton]
        
        myToolbar.addSubview(self.createTitleView()!)
    }
    
    func createTitleView() -> UIView? {
        let titleView = UIView(frame: CGRect(x: 50, y: 0, width: self.view.frame.size.width - 100, height: 44))
        titleView.backgroundColor = UIColor.clear
        titleView.tag = 2000
        let buttonTitle = ""
        
        titleButton = UIButton.init(type: UIButtonType.custom)
        titleButton.tag = 3000
        titleButton.setImage(UIImage(named: "homeDropDown"), for: UIControlState.normal)
        titleButton.setTitle("\(buttonTitle)", for: UIControlState.normal)
        titleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleButton.titleLabel?.textAlignment = NSTextAlignment.left
        titleButton.titleLabel?.lineBreakMode = .byTruncatingTail
        titleButton.frame = CGRect(x: 0, y: 0, width: (buttonTitle.width(withConstraintedHeight: 22, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light))) + 20, height: 44)
        titleButton.backgroundColor = UIColor.clear
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12)
        titleButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleButton.addTarget(self, action: #selector(tapOnCityButton), for: .touchUpInside)
        titleView.addSubview(titleButton)
        
        return titleView
    }
    
     @objc func tapOnCityButton(sender: UIButton?) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HASearchCityViewController") as! HASearchCityViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func addImagesInScrollView() {
        for i in 0..<8 {
            let xPoint: CGFloat = CGFloat((i*81))
            let img = UIImageView.init(frame: CGRect(x:xPoint,y:0,width:80, height:bottomScrollView.frame.size.height))
            img.image =  UIImage(named: "hospitalLogo_\(i+1)")
            img.backgroundColor = UIColor.white
            img.contentMode = .center
            bottomScrollView.addSubview(img)
        }
        bottomScrollView.contentSize = CGSize(width:81*8, height:bottomScrollView.frame.size.height)
    }
    
    @IBAction func tapRecenter_btn(_ sender: UIButton) {
        
        let location = CLLocationCoordinate2D(latitude: currentlatitude, longitude: currentLongitude)
        let bounds = GMSCoordinateBounds(coordinate: location, coordinate: location)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 20.0))
        mapView.animate(toZoom: 13.0)
        
    }
    
    @IBAction func tapOnRightArrowBtn(_ sender: UIButton) {
        let offset = bottomScrollView.contentOffset.x
        if offset >= 81*4 {
            return
        }
        else {
            bottomScrollView.contentOffset = CGPoint(x:offset+81, y:0)
        }
    }
    
    @IBAction func tapOnLeftArrowBtn(_ sender: UIButton) {
        let offset = bottomScrollView.contentOffset.x
        if offset <= 0 {
            return
        }
        else {
            bottomScrollView.contentOffset = CGPoint(x:(offset-81 <= 0) ? 0 : offset-81, y:0)
        }
    }
    
    @objc func tapOnUpdateButton() {
        
    }
    
    @IBAction func tapOnCoinButton(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "HABuyServicesViewController") as! HABuyServicesViewController
//        controller.navigationController?.navigationItem.title = "BUY SERVICES"
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func expandCollaspCollectionView(_ sender: UIButton) {
        if serviceDetailArr.count <= 4 {
            return
        }
        
        if isExpanded == true {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.collectionViewHeightConstraint.constant =  87
                self.topViewHeightConstraint.constant = 125
                sender.isSelected = false
                self.isExpanded = false
                self.view.layoutIfNeeded()
            },
            completion: { finished in
                
            })
        }
        else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                sender.isSelected = true
                self.isExpanded = true
                //TODO
                let width = UIScreen.main.bounds.size.width
                let count = (self.serviceDetailArr.count)/(width == 320 ? 3 : 4)
                self.topViewHeightConstraint.constant = CGFloat(125+(count*100))
                self.collectionViewHeightConstraint.constant = CGFloat(87+(count*100))

                self.homeCollectionView.reloadData()
                //self.view.layoutIfNeeded()
            },
            completion: { finished in
                
            })
        }
    }
    
    func fetchUserLocation() {
        if !isConnectedToNetwork() {
            return
        }
        self.mapView?.isMyLocationEnabled = true
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func refreshDataOnMap(_ lat: String, lot: String, addr: String) {
        titleButton.setTitle("\(addr)", for: UIControlState.normal)
        var width = (addr.width(withConstraintedHeight: 22, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light))) + 20
        if width > self.view.frame.size.width - 100 {
            width = self.view.frame.size.width - 100
        }
        titleButton.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        latStr = lat
        longStr = lot
        
        let location = CLLocationCoordinate2D(latitude: Double(lat) ?? currentlatitude, longitude: Double(lot) ?? currentLongitude)
        let camera = GMSCameraPosition.camera(withLatitude: (location.latitude), longitude: (location.longitude), zoom: 13.0)
        self.mapView?.animate(to: camera)
        
        self.getServiceProvider()
    }
    
    func showMarkersOnMap() {
        let providerList = HADatabase.shared.getProviderListFromDatabase()
        if providerList.count < 1 {
            return
        }
        
        for i in 0..<providerList.count {
            if let dict = providerList[i] as? Dictionary<String, Any> {
                var lati: Double = 0
                var longi: Double = 0
                var imgName = ""
                if let lat = dict["latitude"] as? String {
                    lati = Double(lat) ?? 0
                }
                if let long = dict["longitude"] as? String {
                    longi = Double(long) ?? 0
                }
                if let img = dict["icon_image_url"] as? String {
                    imgName = img
                }
                
                let coordinates = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                let marker = GMSMarker(position: coordinates)
                marker.map = self.mapView
                
                let view = UIView.init(frame: CGRect(x:0,y:0,width:64, height:127))
                view.backgroundColor = UIColor.clear
                
                let img = UIImageView.init(frame: CGRect(x:0,y:49,width:64, height:78))
                img.image = UIImage(named: "markerDefault")
                img.backgroundColor = UIColor.clear
                view.addSubview(img)
                //Sub Image
                let subimg = UIImageView.init(frame: CGRect(x:18,y:65,width:27, height:27))
                subimg.image = UIImage(named: imgName.isEmpty ? "defaultMapPin_icon" : imgName)
                subimg.contentMode = .center
                subimg.backgroundColor = UIColor.clear
                view.addSubview(subimg)
                
                //Top Image
                var imgArr = [UIImage]()
                if let subListArr = dict["available_services"] as? NSArray {
                    for j in 0..<subListArr.count {
                        let subImgName: String = ((subListArr.object(at: j) as! NSDictionary).value(forKey: "image") as! String)
                        if !subImgName.isEmpty {
                            imgArr.append(UIImage(named: subImgName)!)
                        }
                    }
                }
                
                
                let img1 = UIImageView.init(frame: CGRect(x:7.5,y:20,width:49, height:49))
                img1.backgroundColor = UIColor.clear
                img1.animationImages = imgArr
                img1.animationDuration = 5
                img1.startAnimating()
                view.addSubview(img1)
                
                marker.iconView = view
                marker.iconView?.tag = i
            }
            
        }
    }
    
    func getPackageDetail() {
        
        if !isConnectedToNetwork() {
            self.showOkAlert("Oops! no internet connection.")
            
        }else{
            
            //let userdata = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.value(forKey: "UserProfile") as! Data) as! NSDictionary
            //var relationId = ""
            let relationId = HALoggedInUser.shared.getUserFamilyRelationId()
            if relationId == "0"{
                buyFlag = "Y"
            }
            
            var memId = HALoggedInUser.shared.getUserMemberId()
            if memId.isEmpty {
                memId = "0"
            }
            let userdetails = ["user_id": HALoggedInUser.shared.getUserId(),"member_id": memId ,"longitude": longStr,"BuyFlag": buyFlag] as [String : Any]
            let params = ["user_details": userdetails,] as [String : Any]
            
            HASwiftLoader.show(animated: true)
            
            Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "GetPackageDetails", params: params as! [String: NSObject]){ (receivedData) in
                
                print(receivedData)
                HASwiftLoader.hide()

                if Singleton.shared.connection.responceCode == 1{
                    
                    if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                        
                        if String(describing: ((receivedData.value(forKey: "package_details") as! NSArray).firstObject as! NSDictionary).value(forKey: "PlanType")!) == "Credit"{
                         
                            self.planType = "Y"
                        }
                        HADatabase.shared.SavePackageDetails(packageDetails: receivedData.value(forKey: "package_details") as! NSArray)
                        
                        self.serviceDetailArr = ((receivedData.value(forKey: "package_details") as! NSArray).firstObject as! NSDictionary).value(forKey: "service_details") as! Array<Dictionary<String, Any>>
                        if self.serviceDetailArr.count > 4{
                         
                            self.expandCollaspeButton.isHidden = false
                        }
                        self.homeCollectionView.reloadData()
                        self.getServiceProvider()
                        
                    }else{
                        
                        self.showOkAlert(String(describing: receivedData.value(forKey: "message")!))
                    }
                    
                }else{
                    
                    self.showOkAlert(String(describing: receivedData.value(forKey: "Error")!))
                }
            }
        }
    }
    
    //Get Service Provider
    func getServiceProvider() {
        
        if !isConnectedToNetwork() {
            self.showOkAlert("Oops! no internet connection.")
        }else{
            
            let userDetail = ["user_id": HALoggedInUser.shared.getUserId(), "latitude": latStr, "longitude": longStr, "Credit": self.planType, "BuyFlag": buyFlag] as [String : Any]
            
            let params = ["user_details": userDetail,] as [String : Any]
            
            HASwiftLoader.show(animated: true)
            
            Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "getServiceProvider", params: params as! [String: NSObject]){ (receivedData) in
                
                print(receivedData)
                HASwiftLoader.hide()
                
                if Singleton.shared.connection.responceCode == 1{
                    
                    if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                        
                        self.serviceProviderListArr.removeAll()
                        self.mapView.clear()
                        if let arr = receivedData.value(forKey: "service_provider_list") {
                            if arr is [Dictionary<String, Any>] {
                                self.serviceProviderListArr = arr as! [Dictionary<String, Any>]
                                HADatabase.shared.SaveServiceProviderData(providerList: self.serviceProviderListArr as NSArray)
                                self.showMarkersOnMap()
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
}

extension HAHomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let tag = marker.iconView?.tag {
            if let dict = self.serviceProviderListArr[tag] as? Dictionary<String, Any> {
                print(dict)
                
                showPopUP(dataToShow: dict as NSDictionary)
            }
        }
        
        return true
    }
    
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        
//    }
}

extension HAHomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last

        currentlatitude = (location?.coordinate.latitude)!
        currentLongitude = (location?.coordinate.longitude)!
        latStr = String(currentlatitude)
        longStr = String(currentLongitude)
        
        let locationManager: CLLocation = CLLocation(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        self.getAddressFromLocation(locationManager)
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 13.0)
        self.mapView?.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        
        self.getPackageDetail()
    }
    
    func getAddressFromLocation(_ locationManager: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(locationManager, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("ERROR:" + error!.localizedDescription)
                return
            }
            if let pm = placemarks?.first {
                
                let addr = "\(pm.subLocality ?? ""), "+"\(pm.locality ?? "")"
               var width = (addr.width(withConstraintedHeight: 22, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light))) + 20
                if width > self.view.frame.size.width - 100 {
                    width = self.view.frame.size.width - 100
                }
                self.titleButton.setTitle("\(addr)", for: UIControlState.normal)
                self.titleButton.frame = CGRect(x: 0, y: 0, width: (addr.width(withConstraintedHeight: 22, font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light))) + 20, height: 44)
               
            }
            else {
                print("Error with data")
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        HASwiftLoader.hide()
    }
    
    private func convertDegreesToString(degrees: CLLocationDegrees, posDir: String, negDir: String) -> String {
        let direction = (degrees > 0) ? posDir : negDir
        let absDegrees: Double = abs(degrees)
        let degs = Int(absDegrees)
        let minutes = Int(60 * (absDegrees - Double(degs)))
        let seconds = 3600 * (absDegrees - Double(degs))  - 60 * Double(minutes)
        
        return String(format: "%d°%d'%.1f''", arguments: [abs(degs), minutes, seconds]) + direction
    }
}

extension HAHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isExpanded == true {
            return serviceDetailArr.count
        }
        else {
            return (serviceDetailArr.count > 4) ? 4 : serviceDetailArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HAHomeCollectionViewCell", for: indexPath as IndexPath) as! HAHomeCollectionViewCell
        
        cell.iconImgView.image = UIImage(named: (serviceDetailArr[indexPath.item]["FacilityCode"] as? String) ?? "")
        cell.iconNameLbl.text = serviceDetailArr[indexPath.item]["Service_Name"] as? String
        let st = serviceDetailArr[indexPath.item]
        if let count = st["total_available"] as? Int {
            cell.totalCountLbl.text = "\(count)"
        }
        
        return cell
        
    }
}

extension HAHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let serviceCode = String(describing: (serviceDetailArr[indexPath.item] as NSDictionary).value(forKey: "FacilityCode")!)
        
        switch serviceCode {
        case "DC":
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HAProviderListVC") as! HAProviderListVC
            let dict = serviceDetailArr[indexPath.item]
            if let code = dict["service_id"] as? Int {
                controller.facilityCode = "\(code)"
            }
            if let count = dict["total_available"] as? Int {
                controller.available = String(describing: count)
            }
            if let count = dict["consumed"] as? Int {
                controller.consumed = String(describing: count)
            }
            controller.latStr = latStr
            controller.longStr = longStr
            controller.creditStr = self.planType
            controller.cityNameStr = (self.titleButton.titleLabel?.text) ?? ""
            controller.titleStr = (serviceDetailArr[indexPath.item]["Service_Name"] as? String)!
            self.navigationController?.pushViewController(controller, animated: true)
        case "SC":
            self.ServicesAvailable_data = serviceDetailArr[indexPath.item] as NSDictionary
            serviceselected = "SC"
            self.showServicesAvailable()
            
        case "TDR":
            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HABookingViewController") as! HABookingViewController
            vc.data = self.serviceDetailArr[indexPath.item] as NSDictionary
            self.navigationController?.pushViewController(vc, animated: true)
        case "NT":
            let storyboard = UIStoryboard(name: "Booking", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HABookingViewController") as! HABookingViewController
            vc.data = self.serviceDetailArr[indexPath.item] as NSDictionary
            self.navigationController?.pushViewController(vc, animated: true)
        case "HS":
            serviceselected = "HS"
            ServicesAvailable_data = serviceDetailArr[indexPath.item] as NSDictionary
            self.showServicesAvailable()
        default:
            return
        }
        
    }
}

extension HAHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


extension HAHomeViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
