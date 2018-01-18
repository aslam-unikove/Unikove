//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit
import SDWebImage

class ImageHeaderView : UIView {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet var profileButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.layoutIfNeeded()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.clipsToBounds = true
        
        nameLbl.text = HALoggedInUser.shared.getUserName()
        emailLbl.text = HALoggedInUser.shared.getUserEmail()
        profileImage.sd_setImage(with: URL(string: HALoggedInUser.shared.getUserProfileImage()), placeholderImage: UIImage(named: "profile"))
    }
}
