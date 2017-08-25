//
//  ChallengesCell.swift
//  FutLife
//
//  Created by Rene Santis on 8/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ChallengesCell: CustomTableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var defiantAvatar: UIImageView!
    @IBOutlet weak var defiantNameLabel: UILabel!
    @IBOutlet weak var defiantConsoleLb: UILabel!
    
    @IBOutlet weak var rivalAvatar: UIImageView!
    @IBOutlet weak var rivalNameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var rivalConsoleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setUpView(challenge: Challenges, players: [User]) {
        if let players = matchPlayer(challenge: challenge, players: players) {
            amountLabel.textColor = UIColor().greenDefault()
            let intValue: Float = Float(challenge.initialValue!)!
            amountLabel.text = "$\(intValue)"
            gameImageView.image = setGameImage(consoleId: challenge.consoleId!)
            
            let placeholderImage = UIImage(named: "avatar_placeholder")!
            if let p1 = players.playerOne {
                defiantAvatar.circularView(borderColor: UIColor().greenDefault())
                defiantNameLabel.text = !(p1.userName?.isEmpty)! ? players.playerOne?.userName : "¡UNETE!"
                if (p1.avatar != nil) {
                    defiantAvatar.af_setImage(withURL: URL(string: (p1.avatar)!)!, placeholderImage: placeholderImage)
                } else {
                    defiantAvatar.image = placeholderImage
                }
            } else {
                defiantAvatar.circularView(borderColor: UIColor().red())
                defiantNameLabel.text = "¡UNETE!"
                defiantAvatar.image = placeholderImage
            }
            
            
            if let p2 = players.playerTwo {
                rivalAvatar.circularView(borderColor: UIColor().greenDefault())
                rivalNameLabel.text = !(p2.userName?.isEmpty)! ? p2.userName : "¡UNETE!"
                if (p2.avatar != nil) {
                    rivalAvatar.af_setImage(withURL: URL(string: (p2.avatar)!)!, placeholderImage: placeholderImage)
                } else {
                    rivalAvatar.image = placeholderImage
                }
            } else {
                rivalAvatar.circularView(borderColor: UIColor().red(), stroke: 2)
                rivalNameLabel.text = "¡UNETE!"
                rivalAvatar.image = placeholderImage
            }
        }
    }
    
    private func matchPlayer(challenge: Challenges, players: [User]) -> (playerOne: User?, playerTwo: User?)? {
        var playerOneMatch: User?
        var playerTwoMatch: User?
        for player: User in players {
            if "\(player.id!)" == challenge.playerOne! {
                playerOneMatch = player
            } else if let p2 = challenge.playerTwo {
                if "\(player.id!)" == p2 {
                    playerTwoMatch = player
                }
            }
        }
        
        return (playerOneMatch, playerTwoMatch)
    }
    
    private func setGameImage(consoleId: String) -> UIImage {
        var gameName: String
        switch consoleId {
        case "1":
            gameName = "fifa16_mini"
        case "2":
            gameName = "fifa17_mini"
        case "3":
            gameName = "pes16_mini"
        case "4":
            gameName = "pes17_mini"
        default:
            gameName = "fifa16_mini"
        }
        
        return UIImage(named: gameName)!
    }
}
