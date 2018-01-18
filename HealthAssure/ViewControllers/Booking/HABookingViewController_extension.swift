//
//  HABookingViewController_extension.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/17/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import Foundation
import UIKit

extension HABookingViewController{
    
    @objc func tapDateSlot_view(){
        
        pickdate.frame = self.view.frame
        
        pickdate.cancel_btn.action = #selector(removeDatePick_btn)
        pickdate.done_btn.action = #selector(tapDone_btn)
        
        pickdate.date_picker.datePickerMode = .date
        
        
        self.view.addSubview(pickdate)
        
    }
    
    @objc func removeDatePick_btn(){
        
        pickdate.removeFromSuperview()
        
    }
    
    @objc func tapDone_btn(){
        
        let format = DateFormatter()
        format.dateFormat = "MMM dd, yyyy"
        var selecteddate = format.string(from: pickdate.date_picker.date)
        print(selecteddate)
        //pickdate.removeFromSuperview()
    }
    
}

