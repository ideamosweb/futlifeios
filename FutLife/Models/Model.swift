//
//  Model.swift
//  FutLife
//
//  Created by Rene Santis on 5/11/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

import ObjectMapper

class Model: Mappable {
    var token: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]        
    }
}

struct ErrorModel {
    var error: String?
    var message:String?
    var success: Bool?
}
