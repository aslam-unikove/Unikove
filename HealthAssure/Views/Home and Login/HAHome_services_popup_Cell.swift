//
//  HAHome_services_popup_TableViewCell.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/15/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAHome_services_popup_Cell: UITableViewCell {

    @IBOutlet var service_imgView: UIImageView!
    @IBOutlet var service_lbl: UILabel!
    @IBOutlet var count_lbl: UILabel!
    @IBOutlet var leading_service_lbl: NSLayoutConstraint!

    override func awakeFromNib() {
        
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }

}
