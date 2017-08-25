//
//  PlayerOptionsView.swift
//  FutLife
//
//  Created by Rene Santis on 8/22/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayerOptionsView: UIView {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var delegate: PlayerListProtocol?
    
    @IBAction func onProfileButtonTouch(_ sender: Any) {
        
    }
    
    @IBAction func onChallengeButtonTouch(_ sender: Any) {
        
    }
    
    @IBAction func onConsolesButtonTouch(_ sender: Any) {
        
    }
    
    @IBAction func onStatiticsButtonTouch(_ sender: Any) {
        
    }    
    
    @IBAction func onCloseButtonTouch(_ sender: Any) {
        DispatchQueue.main.async {
            if let delegate = self.delegate {
                delegate.closePlayerOptionsView()
            }
        }
    }
    
    func setUpView(player: User) {
        nameLabel.text = player.name
        userNameLabel.text = player.userName
        
        avatar.circularView(borderColor: UIColor.lightGray)
        
        let placeholderImage = UIImage(named: "loading_placeholder")!
        
        if (player.avatar != nil) {
            avatar.af_setImage(withURL: URL(string: player.avatar!)!, placeholderImage: placeholderImage)
        } else {
            avatar.image = placeholderImage
        }
    }
}
