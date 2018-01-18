//
//  HAHomeCollectionViewCell.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 03/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var iconImgView: UIImageView!
    @IBOutlet var iconNameLbl: UILabel!
    @IBOutlet var totalCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImgView.layer.cornerRadius = iconImgView.frame.size.width/2
        iconImgView.clipsToBounds = true
        iconImgView.layer.borderWidth = 1
        iconImgView.layer.borderColor = UIColor.getRGBColor(199, g: 199, b: 199).cgColor
    }
    
}
