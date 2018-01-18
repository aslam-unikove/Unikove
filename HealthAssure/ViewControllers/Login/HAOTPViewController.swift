//
//  HAOTPViewController.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 26/12/17.
//  Copyright © 2017 Unikove. All rights reserved.
//

import UIKit

class HAOTPViewController: UIViewController {

    @IBOutlet var codeTxtField: UITextField!
    @IBOutlet var continueButton: UIButton!
    var regId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        continueButton.layer.cornerRadius = 4
        continueButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
    
    @IBAction func tapOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnContinueButton(_ sender: Any) {
        
        if !isConnectedToNetwork() {
           self.showOkAlert("Oops! no internet connection.")
            
        }else if (codeTxtField.text?.trim().isEmpty)! {
            self.showOkAlert("Please enter access code")
            
        }else{
            
            verifyOTP()
        }
    }
    
    
    //MARK- Webservices
    func verifyOTP(){
        
        let userDetail = ["OTP": codeTxtField.text ?? "","registration_id": self.regId] as [String : Any]
        let params = ["user_details": userDetail,] as [String : Any]
        
        HASwiftLoader.show(animated: true)
        
        Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "OTPConfirmationForRegistration", params: params as! [String: NSObject]) { (receivedData) in
            
            print(receivedData)
            
            HASwiftLoader.hide()
            
            if Singleton.shared.connection.responceCode == 1{
                
                if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                    
                    HADatabase.shared.saveUserProfile(dict: receivedData)
                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: receivedData), forKey: "UserProfile")
                    
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
}

extension HAOTPViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
        
    }
}

