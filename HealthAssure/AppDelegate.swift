//
//  AppDelegate.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 26/12/17.
//  Copyright © 2017 Unikove. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        HADatabase.shared.copyDatabaseIfNeeded()
        IQKeyboardManager.sharedManager().enable = true
        GMSServices.provideAPIKey("\(Constant.GoogleMapsApiKey)")//"AIzaSyAAHqIwfojgo_CVhUlhzJ0jI4yKrBP0Mq0"
        
        let types: UIUserNotificationType = UIUserNotificationType(rawValue: UIUserNotificationType.RawValue(UInt8(UIUserNotificationType.badge.rawValue) |
            UInt8(UIUserNotificationType.alert.rawValue) |
            UInt8(UIUserNotificationType.sound.rawValue)))
        
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()        
        
        let login = UserDefaults.standard.bool(forKey: "IsLogin")
        if login == true {
            self.createHomeMenuView()
        }
        else {
            self.createLoginMenuView()
        }
        
        return true
    }

     func createLoginMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboard1 = UIStoryboard(name: "Home", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HALoginViewController") as! HALoginViewController
        let leftViewController = storyboard1.instantiateViewController(withIdentifier: "HALeftNavigationVC") as! HALeftNavigationVC
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        //UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        //slideMenuController.delegate = mainViewController as SlideMenuControllerDelegate
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    fileprivate func createHomeMenuView() {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "HAHomeViewController") as! HAHomeViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "HALeftNavigationVC") as! HALeftNavigationVC
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        //UINavigationBar.appearance().tintColor = UIColor(hex: "689F38")
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController as SlideMenuControllerDelegate
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        setUserDefault("DeviceToken", value: token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

