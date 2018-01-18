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
    case swift
    case java
    case go
    case nonMenu
    case oneMenu
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
    var swiftViewController: UIViewController!
    var javaViewController: UIViewController!
    var helpHAViewController: UIViewController!
    var nonMenuViewController: UIViewController!
    
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
        let swiftViewController = storyboard.instantiateViewController(withIdentifier: "HAHomeViewController") as! HAHomeViewController
        self.mainViewController = UINavigationController(rootViewController: swiftViewController)
        
        let javaViewController = storyboard.instantiateViewController(withIdentifier: "HABuyServicesViewController") as! HABuyServicesViewController
        self.javaViewController = UINavigationController(rootViewController: javaViewController)
        
        let helpHAViewController = storyboard.instantiateViewController(withIdentifier: "HAAboutHealthAssureVC") as! HAAboutHealthAssureVC
        self.helpHAViewController = UINavigationController(rootViewController: helpHAViewController)
        
        //        let helpViewController = storyboard.instantiateViewController(withIdentifier: "HAAboutHealthAssureVC") as! HAAboutHealthAssureVC
        //        self.helpHAViewController = UINavigationController(rootViewController: helpViewController)
        
        let nib = UINib(nibName: "HALeftVCCell", bundle: nil)
        self.tblView.register(nib, forCellReuseIdentifier: "HALeftVCCell")
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
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
    
    @IBAction func tapOnLogoutBtn(_ sender: Any) {
        let path = HAUtils.getDocumentDirectoryPath() + "/HealthAssure.sqlite";
        let fileManager = FileManager.default
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
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent("HealthAssure.sqlite")
        
        // Delete file in document directory
        if FileManager.default.fileExists(atPath: documentDirectoryFileUrl.path) {
            do {
                if #available(iOS 11.0, *) {
                    try FileManager.default.trashItem(at: documentDirectoryFileUrl, resultingItemURL: nil)
                } else {
                    // Fallback on earlier versions
                    try FileManager.default.removeItem(at: documentDirectoryFileUrl)
                }
            } catch {
                print("Could not delete file: \(error)")
            }
        }
        
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
        case .swift: do {
            //self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
            }
        case .java: do {
            //self.slideMenuController()?.changeMainViewController(self.javaViewController, close: true)
            }
        case .go: do {
            //self.slideMenuController()?.changeMainViewController(self.goViewController, close: true)
            }
        case .nonMenu: do {
            //self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
            }
        case .oneMenu: do {
            //self.slideMenuController()?.changeMainViewController(self.nonMenuViewController, close: true)
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

