//
//  RegisterAvatar.swift
//  FutLife
//
//  Created by Rene Santis on 7/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class RegisterAvatar: Mappable {
    var token: String?
    var message: String?
    var avatar: String?
    var thumbnail: String?
    var success: Bool?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        message <- map["message"]
        avatar <- map["avatar"]
        thumbnail <- map["thumbnail"]
        success <- map["success"]
    }
}

struct RegisterAvatarModel {
    static var token: String?
    static var message: String?
    static var avatar: String?
    static var thumbnail: String?
    static var success: Bool?
}
