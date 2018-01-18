//
//  HAFilterViewController.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/12/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAFilterViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var navigation_view: UIView!
    @IBOutlet var back_img: UIImageView!
    @IBOutlet var cancel_lbl: UILabel!
    @IBOutlet var back_btn: UIButton!
    @IBOutlet var title_lbl: UILabel!
    @IBOutlet var done_btn: UIButton!
    @IBOutlet var distanceTitle_lbl: UILabel!
    @IBOutlet var distance_view: UIView!
    @IBOutlet var distance_slider: UISlider!
    @IBOutlet var distance_lbl: UILabel!
    @IBOutlet var userRatingTitle_lbl: UILabel!
    @IBOutlet var ratings_view: UIView!
    @IBOutlet var HtoL_view: UIView!
    @IBOutlet var HtoL_lbl: UILabel!
    @IBOutlet var HtoL_btn: UIButton!
    @IBOutlet var LtoH_view: UIView!
    @IBOutlet var LtoH_lbl: UILabel!
    @IBOutlet var LtoH_btn: UIButton!
    
    //MARK: Variables
    var selectedRating: String = "Provider_rating DESC"
    var distance = 10
    var delegate: filterValuesDelegates?
    
    //MARK:- Default Actions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadingAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Actions
    @IBAction func tapBack_btn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func tapDone_btn(_ sender: UIButton) {
        
        self.delegate?.valuesforfilter(ratingString: selectedRating, Distance: distance)
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func tapHtoL_btn(_ sender: UIButton) {
        
        toggleAction(coloredView: HtoL_view, borderedView: LtoH_view)
        self.selectedRating = "Provider_rating DESC"
    }
    @IBAction func tapLtoH_btn(_ sender: UIButton) {
        
        toggleAction(coloredView: LtoH_view, borderedView: HtoL_view)
        self.selectedRating = "Provider_rating ASC"
        
    }
    
    @IBAction func valueSlided(_ sender: UISlider) {
        
        distance = Int(sender.value)
        distance_lbl.text = String(describing: distance) + " km"
        
    }
    
    //MARK:- DD's
    
    //MARK:- Functions
    func loadingAction(){
        
        if selectedRating == "Provider_rating DESC"{
            
            self.HtoL_view.backgroundColor = UIColor(red: 122/255, green: 203/255, blue: 189/255, alpha: 1.0)
            self.LtoH_view.backgroundColor = UIColor.white
            self.LtoH_view.layer.cornerRadius = LtoH_view.frame.width/10
            self.LtoH_view.layer.masksToBounds = true
            self.LtoH_view.layer.borderWidth = 1
            self.LtoH_view.layer.borderColor = UIColor.lightGray.cgColor
            
        }else{
            
            self.HtoL_view.backgroundColor = UIColor.white
            self.HtoL_view.layer.cornerRadius = HtoL_view.frame.width/10
            self.HtoL_view.layer.masksToBounds = true
            self.HtoL_view.layer.borderWidth = 1
            self.HtoL_view.layer.borderColor = UIColor.lightGray.cgColor
            self.LtoH_view.backgroundColor = UIColor(red: 122/255, green: 203/255, blue: 189/255, alpha: 1.0)
        }
        
        self.distance_lbl.text = String(describing: distance) + " km"
        self.distance_slider.value = Float(distance) 
        
    }
    
    func toggleAction(coloredView: UIView,borderedView: UIView){
        
        coloredView.backgroundColor = UIColor(red: 122/255, green: 203/255, blue: 189/255, alpha: 1.0)
        coloredView.layer.borderWidth = 0
        coloredView.layer.borderColor = UIColor.white.cgColor
        
        borderedView.backgroundColor = UIColor.white
        borderedView.layer.cornerRadius = borderedView.frame.width/10
        borderedView.layer.masksToBounds = true
        borderedView.layer.borderWidth = 1
        borderedView.layer.borderColor = UIColor.lightGray.cgColor
    
    }
    
    //MARK:- Webservices
}

//MARK:- Protocols

protocol filterValuesDelegates {
    
    func valuesforfilter(ratingString: String,Distance: Int)
}
