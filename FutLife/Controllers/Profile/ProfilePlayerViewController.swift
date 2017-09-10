//
//  ProfilePlayerViewController.swift
//  FutLife
//
//  Created by Rene Santis on 9/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import BLKFlexibleHeightBar

class ProfilePlayerViewController: TabsViewController {
    var avatar: UIImage?
    var name: String!
    var userName: String!
    var player: UserModel!
    var consoles: [ConsoleModel]!
    var games: [GameModel]!
    var selectedButtonView: UIView!
    var userInfoButton: UIButton!
    
    var userInfoTableView: UITableView!
    var gamesTableView: UITableView!
    var consolesTableView: UITableView!
    
    var playerInfo: [Any]!
    let profileType: PlayerProfileType!
    var playerAvatar: UIImageView!
    var avatarSet: Bool = false
    var profileCompleted: (() -> Void?)?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(player: UserModel, type: PlayerProfileType, profileCompleted: (() -> Void)?) {
        self.player = player
        self.profileType = type
        self.profileCompleted = profileCompleted
        
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar(show: true)
        view.backgroundColor = UIColor().darkBlue()
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Utils.screenViewFrame().size.width, height: Utils.screenViewFrame().size.height + 20.0))
        scrollView.contentSize = CGSize(width: Utils.screenViewFrame().size.width, height: Utils.screenViewFrame().size.height + 280.0)
        view.addSubview(scrollView)
        scrollView.bounces = false
        
        /*** FLEXIBLE NAV-BAR ***/
        let myBar: BLKFlexibleHeightBar = BLKFlexibleHeightBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 320.0))
        myBar.minimumBarHeight = 64
        myBar.behaviorDefiner = SquareCashStyleBehaviorDefiner()
        
        scrollView.delegate = myBar.behaviorDefiner as UIScrollViewDelegate
        
        /*** NAVBAR VIEW ***/
        let navBarHeaderFrame = CGRect(x: 0, y: 0, width: Utils.screenViewFrame().size.width, height: 64)
        let navBar = UIView(frame: navBarHeaderFrame)
        navBar.backgroundColor = UIColor().navBarDarkBlue()
        
        myBar.addSubview(navBar)
        
        let initialLayoutAttributesForNB: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForNB.size = navBar.frame.size
        initialLayoutAttributesForNB.center = CGPoint(x: 187, y: 32)
        initialLayoutAttributesForNB.alpha = 0
        
        // This is what we want the bar to look like at its maximum height (progress == 0.0)
        navBar.add(initialLayoutAttributesForNB, forProgress: 0.0)
        
        // Create a final set of layout attributes based on the same values as the initial layout attributes
        let finalLayoutAttributesForNB: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForNB)
        finalLayoutAttributesForNB.alpha = 1.0
        
        // This is what we want the bar to look like at its minimum height (progress == 1.0)
        navBar.add(finalLayoutAttributesForNB, forProgress: 1.0)
        
        /*** BACKGROUND BAR IMAGE ***/
        let bgBarImage = UIImage(named: "headerFlexNavBg")
        let bgBarImageView = UIImageView(frame: myBar.frame)
        bgBarImageView.image = bgBarImage
        bgBarImageView.layer.cornerRadius = 100
        
        myBar.addSubview(bgBarImageView)
        
        let initialLayoutAttributesForBG: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForBG.size = bgBarImageView.frame.size
        initialLayoutAttributesForBG.center = CGPoint(x: myBar.bounds.midX, y: myBar.bounds.midY)
        
        // This is what we want the bar to look like at its maximum height (progress == 0.0)
        bgBarImageView.add(initialLayoutAttributesForBG, forProgress: 0.0)
        
        // Create a final set of layout attributes based on the same values as the initial layout attributes
        let finalLayoutAttributesForBG: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForBG)
        finalLayoutAttributesForBG.alpha = 1.0
        let translationForBG = CGAffineTransform(translationX: 0, y: 0)
        let scaleForBG = CGAffineTransform(scaleX: 1, y: 1)
        let concatTransform = translationForBG.concatenating(scaleForBG)
        finalLayoutAttributesForBG.transform = concatTransform
        
        // This is what we want the bar to look like at its minimum height (progress == 1.0)
        bgBarImageView.add(finalLayoutAttributesForBG, forProgress: 1.0)
        
        /*** AVATAR IMAGE ***/
        playerAvatar = UIImageView(frame: CGRect(x: Utils.screenViewFrame().midX, y: 0.0, width: 150, height: 150))
        playerAvatar.contentMode = .scaleAspectFill
        
        Utils.setAvatar(imageView: playerAvatar)
        playerAvatar.circularView(borderColor: UIColor().greenDefault())
        let gesture = UIGestureRecognizer(target: self, action: #selector(onUserAvatarButtonTouch))
        playerAvatar.addGestureRecognizer(gesture)
        myBar.addSubview(playerAvatar)
        
        let initialLayoutAttributesForAvatar: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForAvatar.size = playerAvatar.frame.size
        initialLayoutAttributesForAvatar.center = CGPoint(x: myBar.bounds.midX, y: 140)
        
        playerAvatar.add(initialLayoutAttributesForAvatar, forProgress: 0.0)
        
        let finalLayoutAttributesForAvatar: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForAvatar)
        finalLayoutAttributesForAvatar.alpha = 0.0
        let translationForAvatar = CGAffineTransform(translationX: 0.0, y: -100.0)
        let scaleForAvatar = CGAffineTransform(scaleX: 0.2, y: 0.2)
        let avatarTransformConcat = translationForAvatar.concatenating(scaleForAvatar)
        finalLayoutAttributesForAvatar.transform = avatarTransformConcat
        
        playerAvatar.add(finalLayoutAttributesForAvatar, forProgress: 1.0)
        
        /*** USERNAME LABEL ***/
        let userNameLb = UILabel()
        userNameLb.text = player.userName
        userNameLb.font = UIFont().bebasFont(size: 27)
        userNameLb.textColor = UIColor.white
        userNameLb.sizeToFit()
        myBar.addSubview(userNameLb)
        
        let initialLayoutAttributesForUserName: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialLayoutAttributesForUserName.size = userNameLb.frame.size
        initialLayoutAttributesForUserName.center = CGPoint(x: myBar.bounds.midX, y: myBar.bounds.midY - 80)
        
        userNameLb.add(initialLayoutAttributesForUserName, forProgress: 0.0)
        
        let finalLayoutAttributesForUserName: BLKFlexibleHeightBarSubviewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialLayoutAttributesForUserName)
        let translationForUserName = CGAffineTransform(translationX: 0.0, y: -myBar.frame.size.height + userNameLb.frame.size.height + 90)
        let scaleForUserName = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let userNameTransConcat = translationForUserName.concatenating(scaleForUserName)
        finalLayoutAttributesForUserName.transform = userNameTransConcat
        
        userNameLb.add(finalLayoutAttributesForUserName, forProgress: 1.0)
        
        view.addSubview(myBar)
    }
    
    
    func onUserAvatarButtonTouch() {
        
    }

}
