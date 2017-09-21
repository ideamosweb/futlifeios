//
//  Cities.swift
//  FutLife
//
//  Created by Rene Alberto Santis Vargas on 9/20/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class Cities: Model {
    var cities: [City]?
    
    override func mapping(map: Map) {
        cities <- map["cities"]
    }
}

class City: Model {
    var id: Int?
    var name: String?
    var active: Bool?
    var countryId: String?
    var countryName: String?
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        active <- map["active"]
        countryId <- map["country_id"]
        countryName <- map["country_name"]
    }
}
