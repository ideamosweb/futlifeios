//
//  PlayersListCell.swift
//  FutLife
//
//  Created by Rene Santis on 8/8/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayersListCell: CustomTableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userOptionsButton: UIButton!
    
    var delegate: PlayerListProtocol?
    var player: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpCell(user: User) {
        player = user
        userNameLabel.text = user.userName
        nameLabel.text = user.name
        
        avatarImageView.circularView(borderColor: UIColor.white)
        
        let placeholderImage = UIImage(named: "avatar_placeholder")!
        
        if (user.avatar != nil) {
            avatarImageView.af_setImage(withURL: URL(string: user.avatar!)!, placeholderImage: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
        
    }
    
    @IBAction func playerOptionsTouchUp(_ sender: Any) {
        userOptionsButton.rotateAnimation(degrees: 120, duration: 0.25)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            DispatchQueue.main.async {
                if let delegate = self.delegate {
                    delegate.playerOptions(player: self.player!)
                }
            }
        }
    }
}
