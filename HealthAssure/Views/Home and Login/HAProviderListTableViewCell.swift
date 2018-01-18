//
//  HAProviderListTableViewCell.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/8/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAProviderListTableViewCell: UITableViewCell {
    
    @IBOutlet var container_view: UIView!
    @IBOutlet var name_lbl: UILabel!
    @IBOutlet var address_lbl: UILabel!
    @IBOutlet var book_btn: UIButton!
    @IBOutlet var rateNow_btn: UIButton!
    @IBOutlet var availability_img: UIImageView!
    @IBOutlet var availability_lbl: UILabel!
    @IBOutlet var availability_btn: UIButton!
    @IBOutlet var seperator_view: UIView!
    @IBOutlet var sos_img: UIImageView!
    @IBOutlet var sos_lbl: UILabel!
    @IBOutlet var sos_btn: UIButton!
    @IBOutlet var rating_lbl: UILabel!
    @IBOutlet var ratingValue_lbl: UILabel!
    @IBOutlet var price_lbl: UILabel!
    @IBOutlet var price_img: UIImageView!
    @IBOutlet var distance_lbl: UILabel!
    @IBOutlet var map_image: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        container_view.layer.cornerRadius = container_view.frame.width/40
        book_btn.layer.cornerRadius = book_btn.frame.width/15
        
        self.container_view.layer.masksToBounds = false
        self.container_view.layer.shadowColor = UIColor.darkGray.cgColor
        //self.container_view.layer.shadowOffset = CGSize(width: -5.0, height: -5.0)
        //self.container_view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.container_view.layer.shadowOffset = CGSize.zero
        self.container_view.layer.shadowRadius = 5.0
        self.container_view.layer.shadowOpacity = 0.8
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        
    }

}
