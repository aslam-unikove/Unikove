//
//  HAAboutHealthAssureVC.swift
//  HealthAssure
//
//  Created by Mohd Aslam on 10/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit
import WebKit

class HAAboutHealthAssureVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var backBtn: UIButton!
    var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        backBtn.addTarget(self.slideMenuController, action: #selector(toggleLeft), for: .touchUpInside)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        HASwiftLoader.show(animated: true)
        let url = URL(string: "\(Constant.kAboutHealthAssure)")
        let request = URLRequest(url: url!)
        
        // init and load request in webview.
        webView = WKWebView(frame: CGRect(x: 0, y: 74, width: self.view.frame.size.width, height: self.view.frame.size.height - 74))
        webView.navigationDelegate = self
        webView.load(request)
        self.view.addSubview(webView)
        self.view.sendSubview(toBack: webView)
        
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
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
         HASwiftLoader.hide()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        HASwiftLoader.hide()
    }
}
