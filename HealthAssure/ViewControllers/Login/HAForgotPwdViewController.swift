//
//  HAForgotPwdViewController.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 26/12/17.
//  Copyright © 2017 Unikove. All rights reserved.
//

import UIKit

class HAForgotPwdViewController: UIViewController {

    @IBOutlet var forgotPwdView: UIView!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        forgotPwdView.layer.cornerRadius = 4
        forgotPwdView.clipsToBounds = true
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
    
}

extension HAForgotPwdViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
        
    }
}

