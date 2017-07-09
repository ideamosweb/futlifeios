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
    var year: Int?
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
        year <- map["year"]
        name <- map["name"]
        avatar <- map["avatar"]
        thumbnail <- map["thumbnail"]
        active <- map["active"]
        createdAt <- (map["created_at"], DateTransform())
        updatedAt <- (map["updated_at"], DateTransform())
    }
}

class ConsoleModel: NSObject, NSCoding {
    let id: Int
    let platformId: Int
    let year: Int
    let name: String
    let avatar: String
    let thumbnail: String
    let active: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(id: Int?, platformId: Int?, year: Int?, name: String?, avatar: String?, thumbnail: String?, active: Bool?, createdAt: Date?, updatedAt: Date?) {
        self.id = id ?? 0
        self.platformId = platformId ?? 0
        self.year = year ?? 0
        self.name = name ?? ""
        self.avatar = avatar ?? ""
        self.thumbnail = thumbnail ?? ""
        self.active = active ?? false
        self.createdAt = createdAt ?? Date()
        self.updatedAt = updatedAt ?? Date()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.platformId = aDecoder.decodeInteger(forKey: "platformId")
        self.year = aDecoder.decodeInteger(forKey: "year")
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as? String ?? ""
        self.thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? String ?? ""
        self.active = aDecoder.decodeBool(forKey: "active")        
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date ?? Date()
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date ?? Date()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(platformId, forKey: "platformId")
        aCoder.encode(year, forKey: "year")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(thumbnail, forKey: "thumbnail")
        aCoder.encode(active, forKey: "active")
        aCoder.encode(createdAt, forKey: "createdAt")
        aCoder.encode(updatedAt, forKey: "updatedAt")
    }
}
