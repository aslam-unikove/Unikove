//
//  HARegistrationCell.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 28/12/17.
//  Copyright © 2017 Unikove. All rights reserved.
//

import UIKit

class HARegistrationCell: UITableViewCell {

    @IBOutlet var nameView: UIView!
    @IBOutlet var genderView: UIView!
    @IBOutlet var accessCodeView: UIView!
    @IBOutlet var nameTxtField: UITextField!
    @IBOutlet var accessTxtField: UITextField!
    @IBOutlet var genderLbl: UILabel!
    @IBOutlet var dropDownImageView: UIImageView!
    
    var isOpen = false
    var dropDownTableView = UITableView()
    var dropDownList = [String]()
    var dismissButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.createDropDownTable()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createDropDownTable() {
        dropDownList = ["Male", "Female"]
        
        dropDownTableView = UITableView(frame: CGRect(x:57,y:250,width:(Int(self.frame.size.width-114)), height:dropDownList.count*44))
        dropDownTableView.backgroundColor = UIColor.white
        dropDownTableView.separatorStyle = .none
        dropDownTableView.isScrollEnabled = false
        dropDownTableView.dataSource = self as UITableViewDataSource
        dropDownTableView.delegate = self as UITableViewDelegate
        dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        
        dropDownTableView.layer.borderColor = UIColor.getRGBColor(223, g: 223, b: 223).cgColor
        dropDownTableView.layer.borderWidth = 1
        dropDownTableView.layer.cornerRadius = 4
        dropDownTableView.clipsToBounds = true
        
    }
    
    @objc func hideDropDownView() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            var rect = self.dropDownTableView.frame
            rect.size.height = 0
            self.dropDownTableView.frame = rect
            self.isOpen = false
            self.dropDownImageView.transform = .identity
            self.layoutIfNeeded()
        },
           completion: { finished in
            self.dropDownTableView.removeFromSuperview()
            self.dismissButton.removeFromSuperview()
            
        })
    }
    
    func createDismissBurron() {
        dismissButton = UIButton.init(type: UIButtonType.custom)
        dismissButton.frame = CGRect(x: 0, y: 0, width: (self.superview?.frame.size.width)!, height: (self.superview?.frame.size.height)!)
        dismissButton.backgroundColor = UIColor.clear
        dismissButton.setTitle("", for: UIControlState.normal)
        dismissButton.addTarget(self, action: #selector(hideDropDownView), for: .touchUpInside)
        self.superview?.insertSubview(dismissButton, belowSubview: self.dropDownTableView)
    }
    
    
    @IBAction func tapOnGenderButton(_ sender: Any) {
        self.endEditing(true)
        self.superview?.endEditing(true)
        
        if self.isOpen {
            self.hideDropDownView()
        }
        else {
            self.superview?.addSubview(self.dropDownTableView)
            self.createDismissBurron()
            
            let view = sender as! UIButton
            let globalPoint = view.convert(view.frame.origin, to: self.superview)
            var rect = self.dropDownTableView.frame
            rect.size.height = 0
            rect.origin.x = 57
            rect.origin.y = (globalPoint.y) + 45
            rect.size.width = (self.frame.size.width-114)
            self.dropDownTableView.frame = rect
            
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var rect = self.dropDownTableView.frame
                rect.size.height = CGFloat(self.dropDownList.count*44)
                self.dropDownTableView.frame = rect
                self.isOpen = true
                self.dropDownImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.layoutIfNeeded()
                
            },
           completion: { finished in
            
            })
        }
    }
    
}

extension HARegistrationCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0: do {
            if !(textField.text?.trim().isEmpty)! {
                registrationInfoDict["FirstName"] = textField.text
            }
            }
        case 1: do {
            if !(textField.text?.trim().isEmpty)! {
                registrationInfoDict["LastName"] = textField.text
            }
            }
        
        case 3: do {
            if !(textField.text?.trim().isEmpty)! {
                registrationInfoDict["Mobile"] = textField.text
            }
            }
        case 4: do {
            if !(textField.text?.trim().isEmpty)! {
                registrationInfoDict["Email"] = textField.text
            }
            }
        case 5: do {
            if !(textField.text?.trim().isEmpty)! {
                registrationInfoDict["Code"] = textField.text
            }
            }
            
        default: do {
            
            }
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 0: do {
            
            }
        case 1: do {
            
            }
        case 3: do {
            guard let text = textField.text else { return true }
            if text.count > 9 {
                return string == ""
            }
            }
        case 4: do {
            
            }
        case 5: do {
            
            }
            
        default: do {
            
            }
            
        }
        
        
        return true
        
    }
}

extension HARegistrationCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = dropDownTableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as UITableViewCell!
        let item =  dropDownList[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        genderLbl.text = dropDownList[indexPath.row]
        registrationInfoDict["Gender"] = dropDownList[indexPath.row]
        self.hideDropDownView()
    }
    
}

