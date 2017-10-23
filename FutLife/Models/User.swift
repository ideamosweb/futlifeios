//
//  User.swift
//  FutLife
//
//  Created by Rene Santis on 5/11/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

enum PlayerProfileType: Int {
    case GamesType
    case InfoType
    case HistoryType
}

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
    var phone: String?
    var birthDate: Date?
    var challenges: [Challenges]?
    var preferences: [Preferences]?
    var balance: Balance?
    
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        userName <- map["username"]
        email <- map["email"]
        avatar <- map["avatar"]
        thumbnail <- map["thumbnail"]
        social <- map["social"]
        active <- map["active"]
        createdAt <- (map["created_at"], DateTransform())
        updatedAt <- (map["updated_at"], DateTransform())
        cityName <- map["city_name"]
        phone <- map["telephone"]
        birthDate <- (map["birthDate"], DateTransform())
        challenges <- map["challenges"]
        preferences <- map["preferences"]
        balance <- map["balance"]
    }
}

class UserModel: NSObject, NSCoding {
    let id: Int
    var name: String
    var userName: String
    var email: String
    let avatar: String
    let thumbnail: String
    let social: Bool
    let active: Bool
    let createdAt: Date
    let updatedAt: Date
    var cityName: String
    var phone: String?
    var birthDate: Date?
    let challenges: [Challenges]?
    var preferences: [PreferencesModel]?
    let balance: Balance?
    
    init(id: Int?, name: String?, userName: String?, email: String?, avatar: String?, thumbnail: String?, social: Bool?, active: Bool?, createdAt: Date?, updatedAt: Date?, cityName: String?, phone: String?, birthDate: Date?, challenges: [Challenges], preferences: [PreferencesModel]?, balance: Balance?) {
        self.id = id ?? 0
        self.name = name ?? ""
        self.userName = userName ?? ""
        self.email = email ?? ""
        self.avatar = avatar ?? ""
        self.thumbnail = thumbnail ?? ""
        self.social = social ?? false
        self.active = active ?? false
        self.createdAt = createdAt ?? Date()
        self.updatedAt = updatedAt ?? Date()
        self.cityName = cityName ?? ""
        self.phone = phone
        self.birthDate = birthDate ?? Date()
        self.challenges = challenges
        self.preferences = preferences
        self.balance = balance
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as? String ?? ""
        self.thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as? String ?? ""
        self.social = aDecoder.decodeBool(forKey: "social")
        self.active = aDecoder.decodeBool(forKey: "active")
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date ?? Date()
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date ?? Date()
        self.cityName = aDecoder.decodeObject(forKey: "cityName") as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        self.birthDate = aDecoder.decodeObject(forKey: "birthDate") as? Date ?? Date()
        self.challenges = aDecoder.decodeObject(forKey: "challenges") as? [Challenges]
        self.preferences = aDecoder.decodeObject(forKey: "preferences") as? [PreferencesModel]
        self.balance = aDecoder.decodeObject(forKey: "balance") as? Balance
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(thumbnail, forKey: "thumbnail")
        aCoder.encode(social, forKey: "social")
        aCoder.encode(active, forKey: "active")
        aCoder.encode(createdAt, forKey: "createdAt")
        aCoder.encode(updatedAt, forKey: "updatedAt")
        aCoder.encode(cityName, forKey: "cityName")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(birthDate, forKey: "birthDate")
        aCoder.encode(challenges, forKey: "challenges")
        aCoder.encode(preferences, forKey: "preferences")
        aCoder.encode(balance, forKey: "balance")
    }
}

class UserUpdate: Model {
    var email: String?
    var userName: String?
    var telephone: String?
    var name: String?
    var birthDate: String?
    var ubication: String?
    
    override func mapping(map: Map) {
        email <- map["email"]
        userName <- map["username"]
        telephone <- map["telephone"]
        name <- map["name"]
        birthDate <- map["birthdate"]
        ubication <- map["ubication"]
    }
}

class UpdateUserResponse: Model {
    var message: String?
    var success: Bool?
    var userUpdate: UserUpdate?
    
    override func mapping(map: Map) {
        message <- map["message"]        
        success <- map["success"]
        userUpdate <- map["user_update"]
    }
}

class ConsolePlayerIdResponse: Model {
    var message: String?
    var success: Bool?
    
    override func mapping(map: Map) {
        message <- map["message"]
        success <- map["success"]
    }
}
