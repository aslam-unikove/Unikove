//
//  HASearchCityViewController.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 04/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit
import GoogleMaps

protocol HASearchCityDelegate {
    func refreshDataOnMap(_ lat: String, lot: String, addr: String)
    func fetchUserLocation()
}

var selectedCityName = ""

class HASearchCityViewController: UIViewController {
    
    @IBOutlet var dropDownView: UIView!
    @IBOutlet var cityNameLbl: UILabel!
    @IBOutlet var dropDownImgView: UIImageView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var detectLocationView: UIView!
    @IBOutlet var searchTxtField: UITextField!
    @IBOutlet var searchTblView: UITableView!
    @IBOutlet var cityListTblView: UITableView!
    @IBOutlet var cityTblHeightConstraint: NSLayoutConstraint!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var dismissBtn: UIButton!
    
    var delegate:HASearchCityDelegate?
    lazy var geocoder = CLGeocoder()
    
    var cityListArr = Array<Dictionary<String, Any>>()
    var searchResultArr = Array<Dictionary<String, Any>>()
    var isOpen = false
    var latitudeStr = ""
    var longitudeStr = ""
    var placename = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchTblView.tableFooterView = UIView.init()
        self.searchTblView.estimatedRowHeight = 44;
        self.searchTblView.rowHeight = UITableViewAutomaticDimension;
        
        dropDownView.layer.cornerRadius = 4
        dropDownView.clipsToBounds = true
        searchView.layer.cornerRadius = 4
        searchView.clipsToBounds = true
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.getRGBColor(214, g: 214, b: 214).cgColor
        
        detectLocationView.layer.cornerRadius = 4
        detectLocationView.clipsToBounds = true
        detectLocationView.layer.borderWidth = 1
        detectLocationView.layer.borderColor = UIColor.getRGBColor(196, g: 227, b: 219).cgColor
        
        cityListTblView.register(UITableViewCell.self, forCellReuseIdentifier: "cityListReuseIdentifier")
        searchTblView.register(UITableViewCell.self, forCellReuseIdentifier:
            "cellReuseIdentifier")
        if selectedCityName.trim().isEmpty {
            
        }
        else {
            self.cityNameLbl.text = selectedCityName
            self.getLocationFromCityName(self.cityNameLbl.text!)
        }
        
        self.getCityList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchTxtField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func tapOnBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnCancelButton(_ sender: Any) {
        searchButton.setImage(UIImage(named:"searchText"), for: .normal)
        searchTxtField.text = ""
        self.searchResultArr.removeAll()
        self.searchTblView.reloadData()
    }
    
    @IBAction func tapOnSearchBtn(_ sender: Any) {
        searchButton.setImage(UIImage(named:"searchText"), for: .normal)
        searchTxtField.text = ""
        self.searchResultArr.removeAll()
        self.searchTblView.reloadData()
    }
    
    @IBAction func tapOnDismissBtn(_ sender: Any) {
        self.hideDropDownView()
    }
    
    @IBAction func tapOnDetectLocationButton(_ sender: Any) {
        self.delegate?.fetchUserLocation()
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func hideDropDownView() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.cityTblHeightConstraint.constant = 0
            self.isOpen = false
            self.dropDownImgView.transform = .identity
            self.view.layoutIfNeeded()
        },
                       completion: { finished in
                        self.dismissBtn.isHidden = true
                        
        })
    }
    
    @IBAction func tapOnDropDownButton(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.isOpen {
            self.hideDropDownView()
        }
        else {
            
            self.dismissBtn.isHidden = false
            
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.cityTblHeightConstraint.constant = self.view.frame.size.height - 120
                self.isOpen = true
                self.cityListTblView.reloadData()
                self.dropDownImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.view.layoutIfNeeded()
                
            },
                           completion: { finished in
                            
            })
        }
    }
    
    func getCityList() {
        
        if !isConnectedToNetwork() {
            self.showOkAlert("Oops! no internet connection.")
        }else{
            
            let userDetail = ["user_id": HALoggedInUser.shared.getUserId()] as [String : Any]
            let params = ["user_details": userDetail] as [String : Any]
            
            HASwiftLoader.show(animated: true)
            
            Singleton.shared.connection.startconnectionWithStringPostParams(urlString: "GetCityName", params: params as! [String: NSObject]){ (receivedData) in
                
                print(receivedData)
                HASwiftLoader.hide()
                
                if Singleton.shared.connection.responceCode == 1{
                    
                    if String(describing: receivedData.value(forKey: "status_code")!) == "200"{
                        
                        self.cityListArr = receivedData.value(forKey: "CityNames") as! [Dictionary<String, Any>]
                        if self.cityListArr.count > 0{
                         
                            if selectedCityName.trim().isEmpty{
                                self.cityNameLbl.text = String(describing: (self.cityListArr.first! as NSDictionary).value(forKey: "city_name")!)
                                self.getLocationFromCityName(self.cityNameLbl.text!)
                            }
                        }
                        
                    }else{
                        
                        self.showOkAlert(String(describing: receivedData.value(forKey: "message")!))
                    }
                    
                }else{
                    
                    self.showOkAlert(String(describing: receivedData.value(forKey: "Error")!))
                }
            }
        }
    }
    
    func getLocationFromCityName(_ city: String) {
        
        let address = "\("India"), \(city)"
        
        // Geocode Address String
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                latitudeStr = "\(coordinate.latitude)"
                longitudeStr = "\(coordinate.longitude)"
            }
        }
    }
    
    func SearchAddressInCity(text: String) {
        if text.trim().isEmpty {
            searchButton.setImage(UIImage(named:"searchText"), for: .normal)
            searchTxtField.text = ""
            self.searchResultArr.removeAll()
            self.searchTblView.reloadData()
            return
        }
        searchButton.setImage(UIImage(named:"searchClose"), for: .normal)

        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(text)&types=address&location=\(latitudeStr),\(longitudeStr)&radius=5000&language=en&key=\(Constant.GooglePlaceApiKey)"
        
        let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%22"))
        if url == nil {
            return
        }
        
        let urlRequest = URLRequest.init(url: url! as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            
            if(error == nil)
            {
                do {
                    let allItems = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
                    
                    self.searchResultArr.removeAll()
                    self.searchResultArr = allItems["predictions"] as! [[String: Any]]
                    print(self.searchResultArr)
                 
                    DispatchQueue.main.async {
                        self.searchTblView.reloadData()
                        
                    }
                }
                catch let error as NSError {
                    print("Found an error - \(error)")
                }
            }
            
        }
        task.resume()
    }
    
    func getDetailFromPlaceId(placeId: String) {
        if placeId.trim().isEmpty {
            
            return
        }
        
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(Constant.GooglePlaceApiKey)"
        
        let url = URL(string: urlString)
        if url == nil {
            return
        }
        
        let urlRequest = URLRequest.init(url: url! as URL)
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            
            if(error == nil)
            {
                do {
                    let allItems = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
                    
                    let result = allItems["result"] as! [String: Any]
                    print(result)
                    var lat = ""
                    var long = ""
                    
                    if let gem = result["geometry"] as? [String: Any]  {
                        if let dict = gem["location"] as? [String: Any] {
                            
                            if let la = dict["lat"] as? Double {
                                lat = "\(la)"
                            }
                            if let lo = dict["lng"] as? Double {
                                long = "\(lo)"
                            }
                        }
                    }
                    
                    var name = ""
                    if result["formatted_address"] as? String != nil {
                        name = result["formatted_address"] as! String
                        print(name)
                    }
                    self.delegate?.refreshDataOnMap(lat, lot: long, addr: self.placename)
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                catch let error as NSError {
                    print("Found an error - \(error)")
                }
            }
            
        }
        task.resume()
    }
}

extension HASearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.cityListTblView {
            return self.cityListArr.count
        }
        return self.searchResultArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.cityListTblView {
            let cell:UITableViewCell = cityListTblView.dequeueReusableCell(withIdentifier: "cityListReuseIdentifier") as UITableViewCell!
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.textLabel?.text = self.cityListArr[indexPath.row]["city_name"] as? String
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
        let cell:UITableViewCell = searchTblView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as UITableViewCell!
        //let item =  dropDownList[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = self.searchResultArr[indexPath.row]["description"] as? String
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.cityListTblView {
            self.cityNameLbl.text = self.cityListArr[indexPath.row]["city_name"] as? String
            searchTxtField.text = ""
            self.hideDropDownView()
            selectedCityName = self.cityNameLbl.text!
            self.getLocationFromCityName(self.cityNameLbl.text!)
        }
        else {
            let dict = self.searchResultArr[indexPath.row]
            print(dict)
            self.placename = ((dict["description"] as? String) ?? "")
            self.getDetailFromPlaceId(placeId: (dict["place_id"] as? String) ?? "")
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.cityListTblView {
            return 30
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
}

extension HASearchCityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        SearchAddressInCity(text: currentText)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}


