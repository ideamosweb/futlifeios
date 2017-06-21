//
//  Game.swift
//  FutLife
//
//  Created by Rene Santis on 5/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class Game: Model {
    var id: Int?
    var year: Int?
    var name: String?
    var avatar: String?
    var thumbnail: String?
    var active: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    
    
    override func mapping(map: Map) {
        id <- map["id"]
        year <- map["year"]
        name <- map["name"]
        avatar <- map["avatar"]
        thumbnail <- map["thumbnail"]
        active <- map["active"]
        createdAt <- (map["created_at"], DateTransform())
        updatedAt <- (map["updated_at"], DateTransform())
    }
}
