//
//  HAUtils.swift
//  HealthAssure
//
//  Created by Brijesh Gupta on 04/01/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import UIKit

class HAUtils: NSObject {

    class func getDeviceInfo() -> Dictionary<String, Any> {
        var devId  = getUserDefault("DeviceId")
        if devId.trim().isEmpty {
            devId = (UIDevice.current.identifierForVendor?.uuidString)!
            setUserDefault("DeviceId", value: devId)
        }
        
        let deviceTokenString  = getUserDefault("DeviceToken")
        let osVersion = UIDevice.current.systemVersion
        let modal = UIDevice.current.model
        let name = UIDevice.current.name
        let systemName = UIDevice.current.systemName
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        
        let deviceInfo = ["device_id": devId ,
                     "device_token": deviceTokenString,
                     "device_osversion": osVersion ,
                     "device_model": modal ,
                     "device_name": name ,
                     "device_type": systemName ,
                     "app_version": appVersion ?? ""
                     ] as [String : Any]
        
    
        return deviceInfo
    }
    
     class func getDocumentDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let docsDir = paths[0];
        return docsDir
    }
}
