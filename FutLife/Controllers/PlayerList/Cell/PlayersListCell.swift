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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpCell(user: User) {
        userNameLabel.text = user.userName
        nameLabel.text = user.name
        
        avatarImageView.circularView()
        
        let placeholderImage = UIImage(named: "loading_placeholder")!
        
        if (user.avatar != nil) {
            avatarImageView.af_setImage(withURL: URL(string: user.avatar!)!, placeholderImage: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
        
    }
}
