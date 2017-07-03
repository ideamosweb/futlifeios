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

class PlatformModel: NSObject, NSCoding {
    let id: Int
    let name: String
    let avatar: String
    let active: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(id: Int, name: String, avatar: String, active: Bool, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.active = active
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as? String ?? ""
        self.active = aDecoder.decodeObject(forKey: "active") as? Bool ?? false
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date ?? Date()
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date ?? Date()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(active, forKey: "games")
        aCoder.encode(createdAt, forKey: "active")
        aCoder.encode(updatedAt, forKey: "updatedAt")
    }
}
