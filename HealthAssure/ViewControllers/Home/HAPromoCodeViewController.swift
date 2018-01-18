//
//  HAPromoCodeViewController.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 03/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAPromoCodeViewController: UIViewController {

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var promoCodeView: UIView!
    @IBOutlet var codeTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        promoCodeView.layer.cornerRadius = 4
        promoCodeView.clipsToBounds = true
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

extension HAPromoCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
        
    }
}

