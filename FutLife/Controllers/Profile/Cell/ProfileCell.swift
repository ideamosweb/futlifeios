//
//  ProfileCell.swift
//  FutLife
//
//  Created by Rene Santis on 7/3/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ProfileCell: CustomTableViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameYearLabel: UILabel!
    @IBOutlet weak var gameNumberLabel: UILabel!
    @IBOutlet weak var consolesView: UIView!
    
    let kConsoleImageWidth: CGFloat = 80.0
    let kConsoleImageHeight: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //selected ? showDetails() : hideDetails()
    }
    
//    func hideDetails() {
//        consolesView.fadeOut(duration: Constants.kDefaultAnimationDuration, closure: {()})
//    }
    
    func showDetails() {
        consolesView.fadeIn(duration: Constants.kDefaultAnimationDuration, closure: {()})
    }
    
    func setGameImage(name: String, gameName: String, gameYear: NSNumber?, gameNumber: String) {
        let imageUrl = URL(string: name)!
        let placeholderImage = UIImage(named: "loading_placeholder")!
        gameImageView.af_setImage(withURL: imageUrl, placeholderImage: placeholderImage)
        
        if gameYear != nil {
            gameYearLabel.text = "\(gameYear!)"
        } else {
            gameYearLabel.isHidden = true
        }
        
        gameNameLabel.text = gameName
        gameNumberLabel.text = gameNumber
    }
    
    func setConsoles(consoles: [ConsoleModel], width: CGFloat) {
        var previousImage: UIImageView?
        
        for subView: UIView in consolesView.subviews {
            subView.removeFromSuperview()
        }
        
        for console: ConsoleModel in consoles {
            if previousImage != nil {
                let consoleImage: UIImageView = UIImageView(frame: CGRect(x: (previousImage?.frame.minX)! - kConsoleImageWidth - 5.0, y: 1.0, width: kConsoleImageWidth, height: kConsoleImageHeight))
                if console.name == "XBOX ONE" {
                    consoleImage.image = UIImage(named: "one_thumb2")
                } else if (console.name == "XBOX 360") {
                    consoleImage.image = UIImage(named: "360_thumb")
                } else if (console.name == "PS3") {
                    consoleImage.image = UIImage(named: "ps3_thumb")
                } else {
                    consoleImage.image = UIImage(named: "ps4_thumb")
                }
                
                consoleImage.contentMode = .scaleAspectFit
                
                previousImage = consoleImage
                consolesView.addSubview(consoleImage)
            } else {
                let consoleImage: UIImageView = UIImageView(frame: CGRect(x: width - kConsoleImageWidth - 5.0, y: 1.0, width: kConsoleImageWidth, height: kConsoleImageHeight))
                
                if (console.name == "XBOX ONE") {
                    consoleImage.image = UIImage(named: "one_thumb2")
                } else if (console.name == "XBOX 360") {
                    consoleImage.image = UIImage(named: "360_thumb")
                } else if (console.name == "PS3") {
                    consoleImage.image = UIImage(named: "ps3_thumb")
                } else {
                    consoleImage.image = UIImage(named: "ps4_thumb")
                }
                
                consoleImage.contentMode = .scaleAspectFit
                
                previousImage = consoleImage
                consolesView.addSubview(consoleImage)
            }
        }
    }
}
