//
//  Singleton.swift
//  HealthAssure
//
//  Created by Akshat K. Rathore on 1/11/18.
//  Copyright © 2018 Unikove. All rights reserved.
//

import Foundation

class Singleton{
    
    static let shared = Singleton()
    
    let connection = webservices()

}
