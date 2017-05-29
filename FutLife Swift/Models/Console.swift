//
//  Console.swift
//  FutLife
//
//  Created by Rene Santis on 5/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class Console: Mappable {
    var id: Int?
    var platformId: Int?
    var name: String?
    var avatar: String?
    var thumbnail: String?
    var active: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        platformId <- map["platform_id"]
        name <- map["name"]
        avatar <- map["avatar"]
        thumbnail <- map["thumbnail"]
        active <- map["active"]
        createdAt <- (map["created_at"], DateTransform())
        updatedAt <- (map["updated_at"], DateTransform())
    }
}