//
//  Platform.swift
//  FutLife
//
//  Created by Rene Santis on 5/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class Platform: Mappable {
    var id: Int?
    var name: String?
    var avatar: String?
    var active: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        avatar <- map["avatar"]
        active <- map["active"]
        createdAt <- (map["created_at"], DateTransform())
        updatedAt <- (map["updated_at"], DateTransform())
    }
}
