//
//  HABuyServicesCell.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 03/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HABuyServicesCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var detailLbl: UILabel!
    @IBOutlet var countView: UIView!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var countLbl: UILabel!
    @IBOutlet var arrowImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width/2
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.getRGBColor(199, g: 199, b: 199).cgColor
        
        minusButton.layer.cornerRadius = 4
        minusButton.clipsToBounds = true
        minusButton.layer.borderWidth = 1
        minusButton.layer.borderColor = UIColor.getRGBColor(243, g: 205, b: 170).cgColor
        
        plusButton.layer.cornerRadius = 4
        plusButton.clipsToBounds = true
        plusButton.layer.borderWidth = 1
        plusButton.layer.borderColor = UIColor.getRGBColor(243, g: 205, b: 170).cgColor
        
        countLbl.layer.cornerRadius = 4
        countLbl.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
