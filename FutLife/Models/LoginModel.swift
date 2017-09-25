//
//  LoginModel.swift
//  FutLife
//
//  Created by Rene Santis on 6/20/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

struct LoginRequest {
    var userName: [String: Any]?
    var password: [String: Any]?
}

class LoginResponse: Mappable {
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

struct LoginModel {
    static var token: String?
    static var success: Bool?
    static var data: User?    
}

class LogoutResponse: Model {
    var success: Bool?
    var message: String?
    
    override func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
    }
}
