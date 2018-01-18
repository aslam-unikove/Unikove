//
//  HAVideoViewController.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/10/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class HAVideoViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var logo_img: UIImageView!
    @IBOutlet var webview: UIWebView!
    @IBOutlet var skip_lbl: UILabel!
    @IBOutlet var skip_icon: UIImageView!
    @IBOutlet var skip_btn: UIButton!
    var videoplayer = AVPlayer()
    var videocontroller = AVPlayerViewController()
    
    //MARK: Variables
    
    //MARK:- Default Actions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "ha_video", ofType: "mp4")
        
        videoplayer = AVPlayer(url: URL(fileURLWithPath: path!))
        videocontroller.player = videoplayer
        videocontroller.view.frame.size = CGSize(width: self.view.frame.width-30, height: self.view.frame.height/4)
        videocontroller.view.center = self.view.center
        self.view.addSubview(videocontroller.view)
        
        videoplayer.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoPlayerFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        videoplayer.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Actions
    @IBAction func tapSkip_btn(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeViewViewController") as! WelcomeViewViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK:- DD's
    //MARK:- Functions
    @objc func videoPlayerFinished(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeViewViewController") as! WelcomeViewViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    //MARK:- Webservices
}

//MARK:- Extensions

