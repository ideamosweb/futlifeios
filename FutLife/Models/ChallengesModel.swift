//
//  ChallengesModel.swift
//  FutLife
//
//  Created by Rene Santis on 8/7/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import ObjectMapper

class ChallengesResponse: Model {
    var data: [Challenges]?
    var success: Bool?
    
    override func mapping(map: Map) {
        data <- map["data"]
        success <- map["success"]
    }
}

class Challenges: Model {
    var id: Int?
    var playerOne: String?
    var playerTwo: String?
    var scorePlayerOne: Int?
    var scorePlayerTwo: Int?
    var consoleId: Int?
    var gameId: Int?
    var amountBet: Float?
    var initialValue: Float?
    var deadLine: Date?
    var state: String?
    var read: Bool?
    var type: String?
    var visibleOne: Bool?
    var visibleTwo: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    var nameOne: String?
    var nameTwo: String?
    
    override func mapping(map: Map) {
        id <- map["id"]
        playerOne <- map["player_one"]
        playerTwo <- map["player_two"]
        scorePlayerOne <- map["score_player_one"]
        scorePlayerTwo <- map["score_player_two"]
        consoleId <- map["console_id"]
        gameId <- map["game_id"]
        amountBet <- map["amount_bet"]
        initialValue <- map["initial_value"]
        deadLine <- map["deadLine"]
        state <- map["state"]
        read <- map["read"]
        type <- map["type"]
        visibleOne <- map["visible_one"]
        visibleTwo <- map["visible_two"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        nameOne <- map["name_one"]
        nameTwo <- map["name_two"]
    }
    
}



struct ChallengesModel {
    static var data: [Challenges]?
    static var success: Bool?

}
