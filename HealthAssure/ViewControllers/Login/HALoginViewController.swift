//
//  HALoginViewController.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 26/12/17.
//  Copyright © 2017 Unikove. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HALoginViewController: UIViewController {

    @IBOutlet var passwordTxtField: UITextField!
    @IBOutlet var userNameTxtField: UITextField!
    @IBOutlet var accessCodeButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    var forgotController = HAForgotPwdViewController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        self.navigationController?.isNavigationBarHidden = true
        
        loginButton.layer.cornerRadius = 4
        loginButton.clipsToBounds = true
        accessCodeButton.layer.cornerRadius = 4
        accessCodeButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
 
    // MARK: - Button Action
    @IBAction func tapOnLoginButton(_ sender: Any) {
        validation()
    }
    
    @IBAction func tapOnForgotPwdButton(_ sender: Any) {
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        forgotController = storyboard.instantiateViewController(withIdentifier: "HAForgotPwdViewController") as! HAForgotPwdViewController
        self.view.addSubview(forgotController.view)
        forgotController.closeButton.addTarget(self, action:#selector(tapOnCloseButton), for: .touchUpInside)
        forgotController.submitButton.addTarget(self, action:#selector(tapOnSubmitButton), for: .touchUpInside)
    }
    
    @IBAction func tapOnAccessCodeButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HARegistrationViewController") as! HARegistrationViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- Functions
    
    func validation(){
        
        
        if !isConnectedToNetwork() {
            
            self.showOkAlert("Oops! no internet connection.")
            
        }else if (userNameTxtField.text?.trim().isEmpty)! {
            
            self.showOkAlert("Please enter user name")
            
        }else if(!HAHelperClass.isValidEmail((userNameTxtField.text?.trim())!)) {
            self.showOkAlert("Please enter valid user name")
            
        }else if (passwordTxtField.text?.trim().isEmpty)! {
            self.showOkAlert("Please enter password")
            
        }else{
            
            login()
        }
    }
    
    @objc func tapOnCloseButton() {
        forgotController.view.removeFromSuperview()
    }
    
    @objc func tapOnSubmitButton(_ sender: Any) {
        
        if !isConnectedToNetwork() {
            self.showOkAlert("Oops! no internet connection.")
            
        }else if (forgotController.emailTxtField.text?.trim().isEmpty)! {
            
            self.showOkAlert("Please enter email id")
            
        }else if(!HAHelperClass.isValidEmail((forgotController.emailTxtField.text?.trim())!)) {
            
            self.showOkAlert("Please enter valid email id")
            
        }else{
            
            forgotPassword()
        }
    }
    //MAKR:- Webservices
    
    func login(){
        
        let deviceInfo = HAUtils.getDeviceInfo()
        let userDetail = ["email": userNameTxtField.text ?? "","password": passwordTxtField.text ?? "",] as [String : Any]
        let loginDetail = ["user_details": userDetail,"device_info": deviceInfo,] as [String : Any]
        let params = ["login_details": loginDetail,] as [String : Any]
        
        HASwiftLoader.show(animated: true)
      
        Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "login", params: params as! [String : NSObject]) { (receivedData) in
            
            print(receivedData)
            
            HASwiftLoader.hide()
            
            if Singleton.shared.connection.responceCode == 1{
                
                if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                    
                    UserDefaults.standard.set(true, forKey: "IsLogin")
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: receivedData), forKey: "UserProfile")
                    
                    HADatabase.shared.saveUserProfile(dict: receivedData)
                    if String(describing: receivedData.value(forKey: "isFirstTimeLogin")!) == "1"{
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "HAVideoViewController") as! HAVideoViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }else{
                        
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "HAHomeViewController") as! HAHomeViewController
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
    
    func forgotPassword(){
        
        let userDetail = ["email": forgotController.emailTxtField.text ?? "",] as [String : Any]
        
        let params = ["user_details": userDetail,] as [String : Any]
        
        HASwiftLoader.show(animated: true)
        
        Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "ForgotPassword", params: params as! [String: NSObject]) { (receivedData) in
            
            print(receivedData)
            
            HASwiftLoader.hide()
            
            if Singleton.shared.connection.responceCode == 1{
                
                if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                    
                    self.forgotController.view.removeFromSuperview()
                    
                    self.showOkAlert("Password sent to your email id")
                 
                }else{
                    self.showOkAlert(String(describing: receivedData.value(forKey: "message")!))
                }
               
            }else{
                self.showOkAlert(String(describing: receivedData.value(forKey: "Error")!))
            }
        }
    }
 
}

extension HALoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

