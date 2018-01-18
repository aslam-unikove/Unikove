//
//  HAHomeVIewController_extension.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/10/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import Foundation
import UIKit

extension HAHomeViewController{
    
    func showPopUP(dataToShow : NSDictionary){
        
        hospitalDetail_popup.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)

        makeCornerRound(view: hospitalDetail_popup.service1_btn)
        makeCornerRound(view: hospitalDetail_popup.service2_btn)
        makeCornerRound(view: hospitalDetail_popup.service3_btn)
        
        showBorder(viewsArray: [hospitalDetail_popup.service1_btn,hospitalDetail_popup.service2_btn,hospitalDetail_popup.service3_btn])
        
        hospitalDetail_popup.popUpMessage_view.layer.cornerRadius = hospitalDetail_popup.popUpMessage_view.frame.width/50
        hospitalDetail_popup.popUpMessage_view.layer.masksToBounds = true
        showShadow(view: hospitalDetail_popup.popUpMessage_view)
        
        hospitalDetail_popup.close_btn.addTarget(self, action: #selector(closepopup), for: .touchUpInside)
       
        hospitalDetail_popup.hospitalname_lbl.text = String(describing: dataToShow.value(forKey: "provicer_name")!)
        hospitalDetail_popup.hospitalAddress_lbl.text = String(describing: dataToShow.value(forKey: "address")!)
        if dataToShow.value(forKey: "contact_number") != nil && String(describing: dataToShow.value(forKey: "contact_number")!) != "<null>"{
            
            hospitalDetail_popup.hospitalContact_lbl.text = String(describing: dataToShow.value(forKey: "contact_number")!)
            
        }else{
            
           hospitalDetail_popup.hospitalContact_lbl.text = "NA"
        }
        hospitalDetail_popup.distance_lbl.text = String(describing: dataToShow.value(forKey: "Distance")!) + " Km"
        
        let logourl = Constant.imageBaseUrl + (String(describing: dataToShow.value(forKey: "icon_image_small_url")!).replacingOccurrences(of: " ", with: "%20")).replacingOccurrences(of: "\\", with: "/")
        let hospitalimageurl = Constant.imageBaseUrl + (String(describing: dataToShow.value(forKey: "gallery_thumbnail_image_url")!).replacingOccurrences(of: " ", with: "%20")).replacingOccurrences(of: "\\", with: "/")
        
        hospitalDetail_popup.logo_img.sd_setImage(with: NSURL(string: logourl)! as URL, placeholderImage: #imageLiteral(resourceName: "hospitalLogo_8"))
        hospitalDetail_popup.hospital_img.sd_setImage(with: NSURL(string: hospitalimageurl)! as URL, placeholderImage: #imageLiteral(resourceName: "hospital"))
        
        self.view.addSubview(hospitalDetail_popup)
    }
    
    func makeCornerRound(view: UIView){
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.width/2
        
    }
    
    func showShadow(view: UIView){
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 3.0
        view.layer.shadowOffset = CGSize.zero
        
    }
    
    func showBorder(viewsArray: Array<UIView>){
        
        for view in viewsArray{
            
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.darkGray.cgColor
            
        }
    }
    
    @objc func closepopup(){
        
        self.hospitalDetail_popup.removeFromSuperview()
        
    }
    
}

extension HAHomeViewController : UITableViewDelegate,UITableViewDataSource{
    
    func showServicesAvailable(){
        
        servicesAvailable_popup.frame = self.view.frame
        
        servicesAvailable_popup.close_btn.addTarget(self, action: #selector(closeServicesPopup), for: .touchUpInside)
        
        let nib = UINib(nibName: "HAHome_services_popup_Cell", bundle: nil)
        self.servicesAvailable_popup.list_tblview.register(nib, forCellReuseIdentifier: "HAHome_services_popup_Cell")
        print(ServicesAvailable_data)
        if (ServicesAvailable_data.value(forKey: "sub_services") as! NSArray).count*70 < 350{
            servicesAvailable_popup.height_list_tblview.constant = CGFloat((ServicesAvailable_data.value(forKey: "sub_services") as! NSArray).count * 70)
            servicesAvailable_popup.list_tblview.isScrollEnabled = false

        }else{
            
            servicesAvailable_popup.height_list_tblview.constant = 350
            servicesAvailable_popup.list_tblview.isScrollEnabled = true
        }
        self.servicesAvailable_popup.list_tblview.rowHeight = 70
        
        self.servicesAvailable_popup.list_tblview.delegate = self
        self.servicesAvailable_popup.list_tblview.dataSource = self
        self.view.addSubview(servicesAvailable_popup)
        
        switch serviceselected{
        case "SC" :
            self.servicesAvailable_popup.title_lbl.text = "Specialist Consultation"
        case "HS":
            self.servicesAvailable_popup.title_lbl.text = "Home Care"
        case "VC" :
            self.servicesAvailable_popup.title_lbl.text = "Vaccination"
        default:
            return
        }
        
        self.servicesAvailable_popup.list_tblview.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (ServicesAvailable_data.value(forKey: "sub_services") as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = servicesAvailable_popup.list_tblview.dequeueReusableCell(withIdentifier: "HAHome_services_popup_Cell", for: indexPath) as! HAHome_services_popup_Cell
        
        switch serviceselected{
            
        case "SC" :
            
            cell.service_imgView.layer.cornerRadius = cell.service_imgView.frame.width/2
            cell.service_imgView.layer.masksToBounds = true
            cell.service_imgView.layer.borderColor = UIColor.black.cgColor
            cell.service_imgView.layer.borderWidth = 1
            cell.count_lbl.isHidden = true
            cell.service_imgView.isHidden = false
            cell.leading_service_lbl.constant = 10
            
        case "HS":
            cell.count_lbl.isHidden = false
            cell.service_imgView.isHidden = true
            cell.leading_service_lbl.constant = -50
            
        case "VC" :
            cell.count_lbl.isHidden = false
            cell.service_imgView.isHidden = true
            cell.leading_service_lbl.constant = -50
        default:
            print("xyz")
        }
       
        cell.service_lbl.text = String(describing: ((ServicesAvailable_data.value(forKey: "sub_services") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Service_Name")!)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HAProviderListVC") as! HAProviderListVC
        let categorydata = (self.ServicesAvailable_data.value(forKey: "sub_services") as! NSArray).object(at: indexPath.row) as! NSDictionary
        vc.facilityCode = String(describing: categorydata.value(forKey: "service_id")!)
        vc.available = String(describing: categorydata.value(forKey: "total_available")!)
        vc.consumed = String(describing: categorydata.value(forKey: "consumed")!)
        vc.latStr = latStr
        vc.longStr = longStr
        vc.creditStr = self.planType
        vc.cityNameStr = (self.titleButton.titleLabel?.text) ?? ""
        vc.titleStr = String(describing: categorydata.value(forKey: "Service_Name")!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func closeServicesPopup(){
        self.servicesAvailable_popup.removeFromSuperview()
    }
}
