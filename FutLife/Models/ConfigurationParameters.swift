//
//  ConfigurationParameters.swift
//  FutLife Swift
//
//  Created by Rene Santis on 5/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class ConfigurationParameters: Mappable {
    var platforms: [Platform]?
    var consoles: [Console]?
    var games: [Game]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        platforms <- map["platforms"]
        consoles <- map["consoles"]
        games <- map["games"]
    }
}

// This struct allow to access to properties model anywhere (like Singleton)
struct ConfigurationParametersModel {
    static var platforms: [Platform]?
    static var consoles: [Console]?
    static var games: [Game]?
}
