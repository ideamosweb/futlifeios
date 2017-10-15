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
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!    
    
    let kConsoleImageWidth: CGFloat = 80.0
    let kConsoleImageHeight: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        selected ? showDetails() : hideDetails()
    }
    
    private func hideDetails() {
        let arrowCollapse = UIImage(named: "arrow_down_collapse")
        arrowImageView.image = arrowCollapse
        consolesView.fadeOut(duration: Constants.kDefaultAnimationDuration, alpha: 0, completion: nil)
    }
    
    private func showDetails() {
        let arrowCollapse = UIImage(named: "arrow_down_expanded")
        arrowImageView.image = arrowCollapse
        consolesView.fadeIn(duration: Constants.kDefaultAnimationDuration, alpha: 1.0, completion: nil)
    }
    
    func hideYearLabel() {
        topConstraint.constant = 14
        gameYearLabel.isHidden = true
    }
    
    func hideArrow() {
        arrowImageView.isHidden = true
    }
    
    func setBg(color: UIColor) {
        backgroundColor = color
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
    
    func setGames(games: [GameModel], width: CGFloat) {
        var previousView: UIView?
        
        for subView: UIView in consolesView.subviews {
            subView.removeFromSuperview()
        }
        
        for game: GameModel in games {
            if previousView != nil {
                let gameViewFrame = CGRect(x: (previousView?.frame.minX)! - (previousView?.frame.width)! - 5, y: (previousView?.frame.origin.y)!, width: (previousView?.frame.width)!, height: (previousView?.frame.height)!)
                
                let ballImage: UIImageView = UIImageView(image: UIImage(named: "ic_football"))
                ballImage.frame = CGRect(x: 2, y: 2, width: 16, height: 16)
                
                let gameName = game.name
                let textSize = (gameName as NSString).size(attributes: [NSFontAttributeName : UIFont().bebasFont(size: 20)])
                let label = UILabel(frame: CGRect(x: ballImage.frame.maxX + 2, y: 2, width: textSize.width, height: textSize.height))
                label.textAlignment = .right
                label.textColor = UIColor.black
                label.font = UIFont().bebasFont(size: 20)
                label.text = game.name
                
                let gameView: UIView = UIView(frame: gameViewFrame)
                gameView.backgroundColor = UIColor().orange()
                gameView.layer.cornerRadius = 5
                gameView.addSubview(ballImage)
                gameView.addSubview(label)
                previousView = gameView
                consolesView.addSubview(gameView)
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
                consolesView.addSubview(gameView)
            }
        }
    }
}
