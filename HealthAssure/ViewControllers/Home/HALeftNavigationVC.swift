//
//  HALeftNavigationVC.swift
//  HealthAssure
//
//  Created by The Local Tribe on 06/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit
import SDWebImage

enum LeftMenu: Int {
    case main = 0
    case appoint
    case account
    case notif
    case feed
    case promotion
    case help
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class HALeftNavigationVC: UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var menus = [["Name":"HOME", "Image":"leftIcon_1"], ["Name":"MY APPOINTMENTS", "Image":"leftIcon_2"], ["Name":"ACCOUNT", "Image":"leftIcon_3"], ["Name":"NOTIFICATIONS", "Image":"leftIcon_4"], ["Name":"FEEDBACK", "Image":"leftIcon_5"], ["Name":"PROMOTIONS", "Image":"leftIcon_6"], ["Name":"ABOUT HEALTH ASSURE", "Image":"leftIcon_7"]
    ]
    var mainViewController: UIViewController!
    var appointmentViewController: UIViewController!
    var accountController: UIViewController!
    var notificationController: UIViewController!
    var feedViewController: UIViewController!
    var helpHAViewController: UIViewController!
    var promotionViewController: UIViewController!
    var profileViewController: UIViewController!
    
    var imageHeaderView: ImageHeaderView!
    var selectedIndex = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBtn.layer.cornerRadius = 4
        logoutBtn.clipsToBounds = true
        logoutBtn.layer.borderWidth = 1
        logoutBtn.layer.borderColor = UIColor.getRGBColor(181, g: 221, b: 213).cgColor
        
        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeController = storyboard.instantiateViewController(withIdentifier: "HAHomeViewController") as! HAHomeViewController
        self.mainViewController = UINavigationController(rootViewController: homeController)
        
        let appointController = storyboard.instantiateViewController(withIdentifier: "HAMyAppointmentsVC") as! HAMyAppointmentsVC
        self.appointmentViewController = UINavigationController(rootViewController: appointController)
        
        let accountVC = storyboard.instantiateViewController(withIdentifier: "HAMyAccountVC") as! HAMyAccountVC
        self.accountController = UINavigationController(rootViewController: accountVC)
        
        let notifVC = storyboard.instantiateViewController(withIdentifier: "HANotificationsVC") as! HANotificationsVC
        self.notificationController = UINavigationController(rootViewController: notifVC)
        
        let feedVC = storyboard.instantiateViewController(withIdentifier: "HAFeedbackVC") as! HAFeedbackVC
        self.feedViewController = UINavigationController(rootViewController: feedVC)
        
        let promoVC = storyboard.instantiateViewController(withIdentifier: "HAPromotionsVC") as! HAPromotionsVC
        self.promotionViewController = UINavigationController(rootViewController: promoVC)
        
        let helpHAViewController = storyboard.instantiateViewController(withIdentifier: "HAAboutHealthAssureVC") as! HAAboutHealthAssureVC
        self.helpHAViewController = UINavigationController(rootViewController: helpHAViewController)
        
        let profileVC = storyboard.instantiateViewController(withIdentifier: "HAUserProfileVC") as! HAUserProfileVC
        self.profileViewController = UINavigationController(rootViewController: profileVC)
        
        let nib = UINib(nibName: "HALeftVCCell", bundle: nil)
        self.tblView.register(nib, forCellReuseIdentifier: "HALeftVCCell")
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
        self.imageHeaderView.profileButton.addTarget(self, action: #selector(tapOnProfileButton), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setProfileData()
    }
    
    func setProfileData() {
        self.imageHeaderView.nameLbl.text = HALoggedInUser.shared.getUserName()
        self.imageHeaderView.emailLbl.text = HALoggedInUser.shared.getUserEmail()
        self.imageHeaderView.profileImage.sd_setImage(with: URL(string: HALoggedInUser.shared.getUserProfileImage()), placeholderImage: UIImage(named: "profile"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
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
    
    @objc func tapOnProfileButton(sender: UIButton?) {
        self.slideMenuController()?.changeMainViewController(self.profileViewController, close: true)
    }
    
    @IBAction func tapOnLogoutBtn(_ sender: Any) {
//        let path = HAUtils.getDocumentDirectoryPath() + "/HealthAssure.sqlite";
//        let fileManager = FileManager.default
//        if fileManager.fileExists(atPath: path) {
//            do {
//                // delete file from documents directory
//                 try fileManager.removeItem(atPath: path)
//
//            } catch let error as NSError {
//                // Catch fires here, with an NSError being thrown
//                print("error occurred, here are the details:\n \(error)")
//            }
//        }
        
        HADatabase.shared.updateDatabaseOnUserLogout()
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.removeObject(forKey: "IsLogin")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.createLoginMenuView()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main: do {
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
            }
        case .appoint: do {
            self.slideMenuController()?.changeMainViewController(self.appointmentViewController, close: true)
            }
        case .account: do {
            self.slideMenuController()?.changeMainViewController(self.accountController, close: true)
            }
        case .notif: do {
            self.slideMenuController()?.changeMainViewController(self.notificationController, close: true)
            }
        case .feed: do {
            self.slideMenuController()?.changeMainViewController(self.feedViewController, close: true)
            }
        case .promotion: do {
            self.slideMenuController()?.changeMainViewController(self.promotionViewController, close: true)
            }
        case .help: do {
            self.slideMenuController()?.changeMainViewController(self.helpHAViewController, close: true)
            }
        }
    }
}

extension HALeftNavigationVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            selectedIndex = indexPath.row
            tblView.reloadData()
            self.changeViewController(menu)
        }
    }
    
}

extension HALeftNavigationVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HALeftVCCell", for: indexPath) as? HALeftVCCell
        cell?.backgroundColor = UIColor.white
        cell?.contentView.backgroundColor = UIColor.white
        cell?.titleLbl.textColor = UIColor.getRGBColor(130, g: 130, b: 130)
        if indexPath.row == selectedIndex {
            cell?.backgroundColor = UIColor.getRGBColor(217, g: 234, b: 255)
            cell?.contentView.backgroundColor = UIColor.getRGBColor(217, g: 234, b: 255)
            cell?.titleLbl.textColor = UIColor.getRGBColor(0, g: 0, b: 61)
        }
        cell?.titleLbl.text = menus[indexPath.row]["Name"]
        cell?.imgView.image = UIImage(named: menus[indexPath.row]["Image"]!)
        return cell!
        
    }
    
    
}

