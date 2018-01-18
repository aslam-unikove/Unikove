//
//  Webservices.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/11/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class webservices {
    
    var responceCode = 0
    
    func startConnectionWithStringGetType(urlString: String,outputblock: @escaping(_ receivedData : NSDictionary)-> Void){

        let url = Constant.kBASEURL + urlString
        print(url)
        
        Alamofire.request(url).responseData { (data) in
  
            if data.result.value != nil{
                
                self.responceCode = 1
                
                let responcedict = (try? JSONSerialization.jsonObject(with: data.result.value! , options: .allowFragments)) as? [AnyHashable: Any]
                outputblock(responcedict! as NSDictionary)
                
            }else{
                
                self.responceCode = 2
                outputblock(["Error": "Oops! something went wrong."])
                
            }
        }
    }
    
    func startconnectionWithStringPostParams(urlString: String,params getparams: [String: NSObject],outputblock: @escaping(_ receivedData: NSDictionary)-> Void){
        
        let url = URL(string: Constant.kBASEURL + urlString)
        print(url!)
        
        DispatchQueue.global().async {
            
            Alamofire.request(url!, method: .post, parameters: getparams,encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                switch response.result{
                    
                case .success(_):
                    
                    self.responceCode = 1
                 
                    let responcedict = NSDictionary(dictionary: (response.result.value! as! Dictionary))
                    outputblock(responcedict.value(forKey: "d") as! NSDictionary)
                    break
                    
                case .failure(let error):
                    
                    self.responceCode = 2
                    outputblock(["Error": error.localizedDescription])
                    break
                    
                }
            }
        }
    }
    
}
