//
//  HARegistrationViewController.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 28/12/17.
//  Copyright © 2017 Unikove. All rights reserved.
//

import UIKit

var registrationInfoDict = Dictionary<String,Any>()

class HARegistrationViewController: UIViewController {

    @IBOutlet var registrationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationInfoDict.removeAll()
        registrationTableView.contentInset = UIEdgeInsetsMake(0, 0, 115, 0)
        let nib = UINib(nibName: "HARegistrationCell", bundle: nil)
        self.registrationTableView.register(nib, forCellReuseIdentifier: "HARegistrationCell")
        registrationTableView.tableFooterView = self.getFooterView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func getFooterView() -> UIView {
        let view: UIView = UIView.init(frame: CGRect(x:0,y:0,width:self.view.frame.size.width, height:74))
        view.backgroundColor = UIColor.clear
        let saveButton = UIButton.init(type: UIButtonType.custom)
        saveButton.frame = CGRect(x: 57, y: 24, width: view.frame.size.width - 114, height: 48)
        saveButton.backgroundColor = UIColor.getRGBColor(32, g: 73, b: 144)
        saveButton.layer.cornerRadius = 4
        saveButton.clipsToBounds = true
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        saveButton.setTitle("CONTINUE", for: UIControlState.normal)
        saveButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        saveButton.addTarget(self, action: #selector(tapOnContinueBtnClicked), for: .touchUpInside)
        view.addSubview(saveButton)
        
        return view
    }
    
    @IBAction func tapOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapOnContinueBtnClicked(sender: UIButton?) {
        
        validtion()
    }
    
    //MARK:- Functions
    
    func validtion(){
   
        if !isConnectedToNetwork() {
            self.showOkAlert("Oops! no internet connection.")
            
        }else if ((registrationInfoDict["FirstName"] as? String ?? "").trim().isEmpty) {
            self.showOkAlert("Please enter first name")
            
            
        }else if ((registrationInfoDict["LastName"] as? String ?? "").trim().isEmpty) {
            self.showOkAlert("Please enter last name")
            
        }else if ((registrationInfoDict["Gender"] as? String ?? "").trim().isEmpty) {
            self.showOkAlert("Please select gender")
            
        }else if ((registrationInfoDict["Mobile"] as? String ?? "").trim().isEmpty) {
            self.showOkAlert("Please enter mobile number")
            
        }else if ((registrationInfoDict["Mobile"] as? String ?? "")).count < 10 {
            self.showOkAlert("Please enter valid mobile number")
            
        }else if ((registrationInfoDict["Email"] as? String ?? "").trim().isEmpty) {
            self.showOkAlert("Please enter email id")
            
        }else if(!HAHelperClass.isValidEmail((registrationInfoDict["Email"] as? String ?? ""))) {
            self.showOkAlert("Please enter valid email id")
            
        }else if ((registrationInfoDict["Code"] as? String ?? "").trim().isEmpty) {
            self.showOkAlert("Please enter access code")
            
        }else{
            
            registerUser()
        }
        
        
        
    }
    
    //MARK:- Webservices
    
    func registerUser(){
        
        let deviceInfo = HAUtils.getDeviceInfo()
        let userDetail = ["first_name":(registrationInfoDict["FirstName"] as? String ?? ""), "last_name": (registrationInfoDict["LastName"] as? String ?? ""),"gender": (registrationInfoDict["Gender"] as? String ?? ""),"mobile_number": (registrationInfoDict["Mobile"] as? String ?? ""),"email": (registrationInfoDict["Email"] as? String ?? ""),"access_code": (registrationInfoDict["Code"] as? String ?? "")] as [String : Any]
        
        let registerDetails = ["user_details": userDetail,"device_info": deviceInfo,] as [String : Any]
        let params = ["registration_details": registerDetails,] as [String : Any]
        
        HASwiftLoader.show(animated: true)
        
        Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "UserSelfRegistration", params: params as! [String: NSObject]) { (receivedData) in
            
            print(receivedData)
            HASwiftLoader.hide()
            
            if Singleton.shared.connection.responceCode == 1{
               
                if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                    
                    if let idStr = receivedData.value(forKey: "registration_id") as? Int{
                     
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "HAOTPViewController") as! HAOTPViewController
                        controller.regId = "\(idStr)"
                        self.navigationController?.pushViewController(controller, animated: true)
                        
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


extension HARegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HARegistrationCell", for: indexPath) as? HARegistrationCell
        
        cell?.nameView.isHidden = false
        cell?.genderView.isHidden = true
        cell?.accessCodeView.isHidden = true
        cell?.nameTxtField.keyboardType = .default
        cell?.nameTxtField.tag = indexPath.row
        cell?.nameTxtField.autocorrectionType = .default
        
        switch indexPath.row {
        case 0: do {
            cell?.nameTxtField.placeholder = "First Name"
        }
        case 1: do {
            cell?.nameTxtField.placeholder = "Last Name"
            }
        case 2: do {
            cell?.nameView.isHidden = true
            cell?.genderView.isHidden = false
            cell?.genderView.layer.cornerRadius = 4
            cell?.genderView.clipsToBounds = true
            cell?.genderView.layer.borderColor = UIColor.getRGBColor(223, g: 223, b: 223).cgColor
            cell?.genderView.layer.borderWidth = 1
            }
        case 3: do {
            cell?.nameTxtField.placeholder = "Mobile Number"
            cell?.nameTxtField.keyboardType = .numberPad
            }
        case 4: do {
            cell?.nameTxtField.placeholder = "Email ID"
            cell?.nameTxtField.keyboardType = .emailAddress
            cell?.nameTxtField.autocorrectionType = .no
            }
        case 5: do {
            cell?.nameView.isHidden = true
            cell?.genderView.isHidden = true
            cell?.accessCodeView.isHidden = false
            cell?.accessTxtField.placeholder = "Enter Access Code"
            cell?.accessTxtField.keyboardType = .default
            cell?.accessTxtField.tag = 5
            }
            
        default: do {
            
            }
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
}
