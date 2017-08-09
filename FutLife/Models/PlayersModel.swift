//
//  PlayersModel.swift
//  FutLife
//
//  Created by Rene Santis on 8/8/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class PlayersResponse: Model {
    var data: [User]?
    var success: Bool?
    
    override func mapping(map: Map) {
        data <- map["data"]
        success <- map["success"]
    }
}

struct PlayersModel {
    static var data: [User]?
    static var success: Bool?
    
}
