//
//  HAUserProfileVC.swift
//  HealthAssure
//
//  Created by Mohd Aslam on 18/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAUserProfileVC: UIViewController {

    @IBOutlet var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backButton.addTarget(self.slideMenuController, action: #selector(toggleLeft), for: .touchUpInside)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        
        self.requestUserProfile()
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

    func requestUserProfile() {
        
        if !isConnectedToNetwork() {
            self.showOkAlert("Oops! no internet connection.")
        }else {
            let userDetail = ["user_id": HALoggedInUser.shared.getUserId()] as [String : Any]
            let params = ["user_details": userDetail,] as [String : Any]
            
            HASwiftLoader.show(animated: true)
            
            Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "GetProfileDetails", params: params as! [String: NSObject]){ (receivedData) in
                
                print(receivedData)
                HASwiftLoader.hide()
                
                if Singleton.shared.connection.responceCode == 1{
                    
                    if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                        
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
