//
//  HAHelperClass.swift
//  HealthAssure
//
//  Created by The Local Tribe on 30/12/17.
//  Copyright © 2017 Unikove. All rights reserved.
//

import UIKit
import SystemConfiguration

var myBundle:Bundle?
var viewBackground:UIView?

class HAHelperClass: NSObject {

    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

//MARK: *************** Extension UIViewController ***************
extension UIViewController
{
    
    func showDescriptionInAlert(_ desc:String,title:String,animationTime:Double,descFont:UIFont) {
        viewBackground?.removeFromSuperview()
        viewBackground = UIView(frame: UIScreen.main.bounds)
        let viewAlertContainer = UIView()
        let txtViewDesc = UITextView()
        viewAlertContainer.backgroundColor = UIColor.white
        viewBackground!.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        txtViewDesc.backgroundColor = UIColor.white
        viewBackground!.alpha = 0.0
        txtViewDesc.text = desc
        txtViewDesc.isEditable = false
        txtViewDesc.font = descFont
        viewAlertContainer.makeRoundCorner(10)
        txtViewDesc.textAlignment = .center
        var txtViewHeight = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width-80, height: 100)
        let height = heightForLabel(desc, width: UIScreen.main.bounds.width-80, font: descFont)
        
        if height > 80 && height < 300 {
            txtViewHeight.size.height = height+20
        }
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 8, width: UIScreen.main.bounds.width-80, height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor.black
        lblTitle.font = UIFont.systemFont(ofSize: 18)
        lblTitle.backgroundColor = UIColor.white
        lblTitle.textAlignment = .center
        txtViewDesc.frame = txtViewHeight
        viewAlertContainer.frame = CGRect(x: 40, y: 100, width: UIScreen.main.bounds.width-80, height: txtViewHeight.size.height+30)
        viewAlertContainer.center = viewBackground!.center
        
        
        viewAlertContainer.addSubview(lblTitle)
        viewAlertContainer.addSubview(txtViewDesc)
        viewBackground!.addSubview(viewAlertContainer)
        self.view.addSubview(viewBackground!)
        
        UIView.animate(withDuration: animationTime) {
            viewBackground!.alpha = 1.0
        }
    }
    
    func hideDescriptionAlert(_ animationTime:Double) {
        UIView.animate(withDuration: animationTime, animations: {
            viewBackground?.alpha = 0.0
        }) { (compelete) in
            if compelete {
                viewBackground?.removeFromSuperview()
            }
        }
    }
    
    
    
    func showOkCancelAlertWithAction(_ msg: String, handler:@escaping (_ isOkAction: Bool) -> Void)
    {
        let alert = UIAlertController(title: "HealthAssure", message: msg, preferredStyle: .alert)
        let okAction =  UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            return handler(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            return handler(false)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showOkAlert(_ msg: String)
    {
        let alert = UIAlertController(title: "HealthAssure", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showOkAlertWithHandler(_ msg: String,handler: @escaping ()->Void)
    {
        let alert = UIAlertController(title: "HealthAssure", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (type) -> Void in
            handler()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: *************** Extension UIView ***************
extension UIView
{
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func makeRoundCorner(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func makeBorder(_ width:CGFloat,color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    
    func addShadow() {
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.getRGBColor(221, g: 221, b: 221).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.5
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func instanceFromNib(name:String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}

//MARK: *************** Global Helper Method ***************
func setLanguage(_ lang:String)
{
    let path    =   Bundle.main.path(forResource: lang, ofType: "lproj")
    if path == nil
    {
        myBundle  = Bundle.main
    }
    else
    {
        myBundle = Bundle(path:path!)
        if (myBundle == nil) {
            myBundle = Bundle.main
        }
    }
}

func localized(_ key:String) -> String
{
    return NSLocalizedString(key, tableName: nil, bundle: myBundle!, value: "", comment: "")
}

func setUserDefault(_ key:String,value:String)
{
    let defaults = UserDefaults.standard
    defaults.set(value, forKey: key)
}

func getUserDefault(_ key:String) ->String
{
    let defaults = UserDefaults.standard
    let val = defaults.string(forKey: key)
    if val != nil
    {
        return val!
    }
    else
    {
        return ""
    }
}

func removeUserDefault(_ key:String){
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: key)
}

func setDictUserDefault(_ detail:Dictionary<String,AnyObject>){
    for (key,value) in detail{
        if(detail[key] != nil){
            print_debug("\(key)")
            setUserDefault(key, value: "\(value)")
        }
    }
}

func heightForLabel(_ text:String,width:CGFloat,font:UIFont) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

func print_debug<T>(_ obj:T)
{
    print(obj)
}


//MARK: *************** Extension String ***************

extension String {
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    func isContainsNumber() -> Bool{
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil {
            return true
        } else {
            return false
        }
    }
    
    func checkContainsLowerAndUpperCase() ->Bool {
        var isLowerCase = false
        var isUpperCase = false
        for char in self {
            if String(char).lowercased() != String(char) { // a != A UpperCase Contains true
                isUpperCase = true
            }
            if String(char).uppercased() != String(char) { // A != a LowerCase Contains true
                isLowerCase = true
            }
        }
        return (isLowerCase == isUpperCase) == true
    }
    
    func checkContainsOnlyNumbers() ->Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func getDateInstance(validFormatter:String)->Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = validFormatter
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: self)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width + 10)
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.count
    }
}

//MARK: *************** Extension UIColor ***************
extension UIColor{
    
    var r: CGFloat{
        return self.cgColor.components![0]
    }
    
    var g: CGFloat{
        return self.cgColor.components![1]
    }
    
    var b: CGFloat{
        return self.cgColor.components![2]
    }
    
    var alpha: CGFloat{
        return self.cgColor.components![3]
    }
    class func getRGBColor(_ r:CGFloat,g:CGFloat,b:CGFloat)-> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    /* Only Working for WIFI
     let isReachable = flags == .reachable
     let needsConnection = flags == .connectionRequired
     
     return isReachable && !needsConnection
     */
    
    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)
    
    return ret
}
