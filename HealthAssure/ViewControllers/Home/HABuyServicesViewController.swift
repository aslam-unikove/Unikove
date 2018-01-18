//
//  HABuyServicesViewController.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 03/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HABuyServicesViewController: UIViewController {

    @IBOutlet var totalAmountLbl: UILabel!
    @IBOutlet var serviceTblView: UITableView!
    var promoController = HAPromoCodeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        let nib = UINib(nibName: "HABuyServicesCell", bundle: nil)
        self.serviceTblView.register(nib, forCellReuseIdentifier: "HABuyServicesCell")
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
    @IBAction func tapOnPromoCodeButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        promoController = storyboard.instantiateViewController(withIdentifier: "HAPromoCodeViewController") as! HAPromoCodeViewController
        self.view.addSubview(promoController.view)
        promoController.closeButton.addTarget(self, action:#selector(tapOnCloseButton), for: .touchUpInside)
        promoController.applyButton.addTarget(self, action:#selector(tapOnApplyButton), for: .touchUpInside)
    }
    
    @objc func tapOnCloseButton() {
        promoController.view.removeFromSuperview()
    }
    
    @objc func tapOnApplyButton(_ sender: Any) {
        if (promoController.codeTxtField.text?.trim().isEmpty)! {
            self.showOkAlert("Please enter promo code")
            return
        }
        promoController.view.removeFromSuperview()
    }
    
}

extension HABuyServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HABuyServicesCell", for: indexPath) as? HABuyServicesCell
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HADiagnosticViewController") as! HADiagnosticViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

