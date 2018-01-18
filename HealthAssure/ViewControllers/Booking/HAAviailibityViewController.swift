//
//  HAAviailibityViewController.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/16/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAAviailibityViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet var navigation_view: UIView!
    @IBOutlet var back_btn: UIButton!
    @IBOutlet var top_view: UIView!
    @IBOutlet var date_lbl: UILabel!
    @IBOutlet var date_value_btn: UIButton!
    @IBOutlet var seperator: UIView!
    @IBOutlet var selecttime_lbl: UILabel!
    @IBOutlet var message_lbl: UILabel!
    @IBOutlet var slots_tblview: UITableView!
    @IBOutlet var book_btn: UIButton!
    //MARK: Variables
    var delegate: timeChoosedDelegate?
    var timeSelected = ""
    var index: IndexPath!
    var collectionView: UICollectionView!
    //MARK:- Default Actions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadingAction()
        slots_tblview.estimatedRowHeight = 150
        slots_tblview.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Actions
    @IBAction func tapBack_btn(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func tapDate_btn(_ sender: UIButton) {
    }
    @IBAction func tapBook_btn(_ sender: UIButton) {
        delegate?.timeSlotSelected(time: timeSelected)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- DD's
    //MARK:- Functions
    func loadingAction(){
        
        self.slots_tblview.delegate = self
        self.slots_tblview.dataSource = self
        
    }
    //MARK:- Webservices
}

//MARK:- Extensions
extension HAAviailibityViewController : UITableViewDelegate,UITableViewDataSource,timeChoosedDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = slots_tblview.dequeueReusableCell(withIdentifier: "HAAvailibilityTableViewCell", for: indexPath) as! HAAvailibilityTableViewCell
        cell.delegate = self
        switch indexPath.row {
        case 0:
            cell.sloType_lbl.text = "MORNING SLOT"
            cell.timeslots = ["8:00 AM","8:30 AM","9:00 AM","9:30 AM","10:00 AM","10:30 AM","11:00 AM","11:30 AM"]
        case 1:
            cell.sloType_lbl.text = "AFTERNOON SLOT"
            cell.timeslots = ["12:00 PM","12:30 PM","1:00 PM","1:30 PM","2:00 PM","2:30 PM"]
        case 2:
            cell.sloType_lbl.text = "EVENING SLOT"
            cell.timeslots = ["3:00 PM","3:30 PM","4:00 PM","4:30 PM","5:00 PM","5:30 PM","6:00 PM","6:30 PM"]
        default:
            break
        }
        
        if cell.slots_collectionview == self.collectionView{
            cell.indexpath = self.index
            cell.selectedCollectionViewOrNot = true
        }else{
            cell.selectedCollectionViewOrNot = false
        }
        cell.slots_collectionview.reloadData()
        return cell
    }
    
    func timeSlotSelected(time: String) {
        timeSelected = time
        
    }
    
    func collectionviewSlotSelectedFrom(collectionView: UICollectionView, index: IndexPath) {
        self.collectionView = collectionView
        self.index = index
        self.slots_tblview.reloadData()
    }
}
