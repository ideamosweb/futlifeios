//
//  User.swift
//  FutLife
//
//  Created by Rene Santis on 5/11/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Model {
    var id: Int?
    var name: String?
    var userName: String?
    var email: String?
    var avatar: String?
    var thumbnail: String?
    var social: Bool?
    var active: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    var cityName: String?
    var challenges: [AnyObject]?    
    
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        userName <- map["username"]
        avatar <- map["avatar"]
        thumbnail <- map["thumbnail"]
        social <- map["social"]
        active <- map["active"]
        createdAt <- (map["created_at"], DateTransform())
        updatedAt <- (map["updated_at"], DateTransform())
        cityName <- map["city_name"]
        challenges <- map["challenges"]
    }
}
