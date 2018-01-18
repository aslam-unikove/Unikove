//
//  WelcomeViewViewController.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/10/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class WelcomeViewViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet var background_img: UIImageView!
    @IBOutlet var titleWelcome_lbl: UILabel!
    @IBOutlet var title_lbl2: UILabel!
    @IBOutlet var title_lbl3: UILabel!
    @IBOutlet var message_lbl: UILabel!
    @IBOutlet var close_btn: UIButton!
    @IBOutlet var gotoprofile_btn: UIButton!
    
    //MARK: Variables
    
    //MARK:- Default Actions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Actions
    
    @IBAction func tapClose_btn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HAHomeViewController") as! HAHomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapProfile_btn(_ sender: Any) {
        
    }
    
    //MARK:- DD's
    //MARK:- Functions
    //MARK:- Webservices
}

//MARK:- Extensions
