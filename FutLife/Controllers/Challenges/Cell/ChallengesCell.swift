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
    @IBOutlet weak var defiantScoreLabel: UILabel!
    @IBOutlet weak var defiantStatusView: UILabel!
    
    @IBOutlet weak var rivalAvatar: UIImageView!
    @IBOutlet weak var rivalNameLabel: UILabel!
    @IBOutlet weak var rivalScoreLabel: UILabel!
    @IBOutlet weak var rivalStatusView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setUpView(challenge: Challenges, players: [User]) {
        if let players = matchPlayer(challenge: challenge, players: players) {
            amountLabel.text = "\(challenge.amountBet ?? 0.0)"
            defiantNameLabel.text = players.playerOne?.name
            defiantScoreLabel.text = "\(challenge.scorePlayerOne ?? 0)"
            
            let placeholderImage = UIImage(named: "loading_placeholder")!
            defiantAvatar.circularView()
            if (players.playerOne?.avatar != nil) {
                defiantAvatar.af_setImage(withURL: URL(string: (players.playerOne?.avatar!)!)!, placeholderImage: placeholderImage)
            } else {
                defiantAvatar.image = placeholderImage
            }
            
            rivalNameLabel.text = players.playerTwo?.name
            rivalScoreLabel.text = challenge.playerTwo
            rivalAvatar.circularView()
            if (players.playerTwo?.avatar != nil) {
                rivalAvatar.af_setImage(withURL: URL(string: (players.playerTwo?.avatar!)!)!, placeholderImage: placeholderImage)
            } else {
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
}
