//
//  Balance.swift
//  FutLife
//
//  Created by Rene Santis on 9/10/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class Balance: Model {
    var userId: Int?
    var documentType: String?
    var documentNumber: String?
    var email: String?
    var value: Float?
    var coin: String?
    var state: String?
    
    override func mapping(map: Map) {
        userId <- map["user_id"]
        documentType <- map["document_type"]
        documentNumber <- map["document_number"]
        email <- map["active"]
        value <- map["value"]
        coin <- map["coin"]
        state <- map["state"]
    }
}

class BalanceModel: NSObject, NSCoding {
    let userId: Int?
    let documentType: String?
    let documentNumber: String?
    let email: String?
    let value: Float?
    let coin: String?
    let state: String?
    
    init(userId: Int?, documentType: String?, documentNumber: String?, email: String?, value: Float?, coin: String?, state: String?) {
        self.userId = userId ?? 0
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.email = email
        self.value = value
        self.coin = coin
        self.state = state
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.userId = aDecoder.decodeInteger(forKey: "userId")
        self.documentType = aDecoder.decodeObject(forKey: "documentType") as? String ?? ""
        self.documentNumber = aDecoder.decodeObject(forKey: "documentNumber") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.value = aDecoder.decodeFloat(forKey: "value")
        self.coin = aDecoder.decodeObject(forKey: "coin") as? String ?? ""
        self.state = aDecoder.decodeObject(forKey: "state") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(documentType, forKey: "documentType")
        aCoder.encode(documentNumber, forKey: "documentNumber")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(coin, forKey: "coin")
        aCoder.encode(state, forKey: "state")
    }
}
