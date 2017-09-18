//
//  PlayerConsolesCell.swift
//  FutLife
//
//  Created by Rene Santis on 9/13/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class PlayerConsolesCell: CustomTableViewCell {
    @IBOutlet weak var consoleImage: UIImageView!
    @IBOutlet weak var consoleName: UILabel!
    @IBOutlet weak var consoleModel: UILabel!
    @IBOutlet weak var gamesView: UIView!
    
    let kConsoleImageWidth: CGFloat = 80.0
    let kConsoleImageHeight: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setGameImage(name: String, gameName: String) {
        let imageUrl = URL(string: name)!
        let placeholderImage = UIImage(named: "loading_placeholder")!
        consoleImage.af_setImage(withURL: imageUrl, placeholderImage: placeholderImage)
        
        consoleName.font = UIFont().bebasBoldFont(size: 16)
        consoleName.text = gameName
        
        consoleModel.font = UIFont().bebasBoldFont(size: 20)
        consoleModel.text = gameName
    }
    
    func setGames(games: [GameModel], width: CGFloat) {
        var previousView: UIView?
        
        for subView: UIView in gamesView.subviews {
            subView.removeFromSuperview()
        }
        
        for game: GameModel in games {
            if previousView != nil {
                let gameViewFrame = CGRect(x: (previousView?.frame.minX)! - (previousView?.frame.width)! - 5, y: (previousView?.frame.origin.y)!, width: (previousView?.frame.width)!, height: (previousView?.frame.height)!)
                
                let nextGameView: UIView = previousView?.mutableCopy() as! UIView
                nextGameView.frame = gameViewFrame
                for subview in nextGameView.subviews {
                    if subview is UILabel {
                        let temp: UILabel = subview as! UILabel
                        temp.text = game.name
                    }
                }
                
                previousView = nextGameView
                gamesView.addSubview(nextGameView)
                
            } else {
                let ballImage: UIImageView = UIImageView(image: UIImage(named: "ic_football"))
                ballImage.frame = CGRect(x: 2, y: 2, width: 16, height: 16)
                
                let gameName = game.name
                let textSize = (gameName as NSString).size(attributes: [NSFontAttributeName : UIFont().bebasFont(size: 20)])
                let label = UILabel(frame: CGRect(x: ballImage.frame.maxX + 2, y: 2, width: textSize.width, height: textSize.height))
                label.textAlignment = .right
                label.textColor = UIColor.black
                label.font = UIFont().bebasFont(size: 20)
                label.text = game.name
                
                let gameView: UIView = UIView(frame: CGRect(x: Utils.screenViewFrame().width - kConsoleImageWidth - 5.0, y: 2.0, width: label.intrinsicContentSize.width + 30, height: kConsoleImageHeight))
                gameView.backgroundColor = UIColor().orange()
                gameView.layer.cornerRadius = 5
                gameView.addSubview(ballImage)
                gameView.addSubview(label)
                previousView = gameView
                gamesView.addSubview(gameView)
            }
        }
    }
}
