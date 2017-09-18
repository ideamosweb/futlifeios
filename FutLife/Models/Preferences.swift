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
    var userId: String?
    var consoleId: String?
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
    let id: Int
    let userId: String
    let consoleId: String
    let playerId: Int
    let active: Bool
    let console: ConsoleModel?
    let games: [GameModel]?
    
    init(id: Int?, userId: String?, consoleId: String?, playerId: Int?, active: Bool?, console: ConsoleModel?, games: [GameModel]?) {
        self.id = id!
        self.userId = userId ?? ""
        self.consoleId = consoleId ?? ""
        self.playerId = playerId ?? 0
        self.active = active ?? false
        self.console = console
        self.games = games
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.userId = aDecoder.decodeObject(forKey: "userId") as? String ?? ""
        self.consoleId = aDecoder.decodeObject(forKey: "consoleId") as? String ?? ""
        self.playerId = aDecoder.decodeInteger(forKey: "playerId")
        self.active = aDecoder.decodeBool(forKey: "active")
        self.console = aDecoder.decodeObject(forKey: "console") as? ConsoleModel
        self.games = aDecoder.decodeObject(forKey: "games") as? [GameModel]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(consoleId, forKey: "consoleId")
        aCoder.encode(playerId, forKey: "playerId")
        aCoder.encode(active, forKey: "active")
        aCoder.encode(console, forKey: "console")
        aCoder.encode(games, forKey: "games")
    }
}
