//
//  Preferences.swift
//  FutLife
//
//  Created by Rene Santis on 7/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class Preferences: Model {
    var id: Int?
    var userId: Int?
    var consoleId: Int?
    var playerId: Int?
    var active: Bool?
    var console: Console?
    var games: [Game]?
    
    override func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        consoleId <- map["console_id"]
        playerId <- map["player_id"]
        active <- map["active"]
        console <- map["console"]
        games <- map["games"]
    }
}

class PreferencesModel: NSObject, NSCoding {
    let id: Int?
    let userId: Int?
    let consoleId: Int?
    let playerId: Int?
    let active: Bool?
    
    init(id: Int?, userId: Int?, consoleId: Int?, playerId: Int?, active: Bool?) {
        self.id = id ?? 0
        self.userId = userId ?? 0
        self.consoleId = consoleId ?? 0
        self.playerId = playerId ?? 0
        self.active = active ?? false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.userId = aDecoder.decodeInteger(forKey: "userId")
        self.consoleId = aDecoder.decodeInteger(forKey: "consoleId")
        self.playerId = aDecoder.decodeInteger(forKey: "playerId")
        self.active = aDecoder.decodeBool(forKey: "active")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(consoleId, forKey: "consoleId")
        aCoder.encode(playerId, forKey: "playerId")
        aCoder.encode(active, forKey: "active")        
    }
}
