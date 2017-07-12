//
//  RegisterModel.swift
//  FutLife
//
//  Created by Rene Santis on 6/22/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class RegisterResponse: Mappable {
    var token: String?
    var success: Bool?
    var data: User?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        success <- map["success"]
        data <- map["data"]
    }
}

struct RegisterModel {
    static var token: String?
    static var success: Bool?
    static var data: User?
}

class RegisterCreateResponse: Model {
    var message: String?
    var preferences: [Preferences]?
    var success: Bool?
    
    override func mapping(map: Map) {
        message <- map["message"]
        preferences <- map["preferences"]
        success <- map["success"]
    }
}
