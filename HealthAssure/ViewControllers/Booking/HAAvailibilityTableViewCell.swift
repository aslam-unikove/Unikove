//
//  HAAvailibilityTableViewCell.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/16/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAAvailibilityTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet var sloType_lbl: UILabel!
    @IBOutlet var slotIcon_img: UIImageView!
    @IBOutlet var slots_collectionview: UICollectionView!
    @IBOutlet var heightofcolllection_view: NSLayoutConstraint!
    var timeslots = [""]
    var indexpath: IndexPath!
    var selectedCollectionViewOrNot = false
    var delegate: timeChoosedDelegate?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        slots_collectionview.dataSource = self
        slots_collectionview.delegate = self
        //heightofcolllection_view.constant = CGFloat((timeslots.count/4) * 37)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeslots.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = slots_collectionview.dequeueReusableCell(withReuseIdentifier: "HAAvailibilityCollectionViewCell", for: indexPath) as! HAAvailibilityCollectionViewCell
        cell.container_view.layer.cornerRadius = cell.container_view.frame.width/15
        cell.container_view.layer.borderColor = UIColor(red: 125/255, green: 203/255, blue: 189/255, alpha: 1.0).cgColor
        cell.container_view.layer.borderWidth = 1
        cell.container_view.backgroundColor = UIColor.white
        cell.slotTime_lbl.textColor = UIColor(red: 125/255, green: 203/255, blue: 189/255, alpha: 1.0)
        cell.slotTime_lbl.text =  timeslots[indexPath.row]
        
        if self.selectedCollectionViewOrNot != false{
            if self.indexpath == indexPath{
                
                cell.container_view.backgroundColor = UIColor(red: 125/255, green: 203/255, blue: 189/255, alpha: 1.0)
                cell.slotTime_lbl.textColor = UIColor.white
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.slots_collectionview.frame.width/4 - 15, height: 25)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? HAAvailibilityCollectionViewCell
        
        if let time = cell?.slotTime_lbl.text{
            
            delegate?.timeSlotSelected(time: time)
            delegate?.collectionviewSlotSelectedFrom!(collectionView: collectionView,index: indexPath)
        }
       
    }
}

@objc protocol timeChoosedDelegate {
    func timeSlotSelected(time: String)
    @objc optional func collectionviewSlotSelectedFrom(collectionView: UICollectionView,index: IndexPath)
}
