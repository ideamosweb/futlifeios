//
//  HomeViewController.swift
//  FutLife
//
//  Created by Rene Santis on 8/7/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class HomeViewController: TabsViewController {
    @IBOutlet weak var balancelabel: UILabel!
    var users: [UserModel] = []
    var darkBackgroundButton: UIButton = UIButton()
    var homeCompletion: () -> Void?
    var darkBgButton: UIButton?
    var playerOptionsView: PlayerOptionsView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(completion: @escaping () -> Void?) {
        homeCompletion = completion        
        super.init(nibName: "HomeViewController", bundle: Bundle.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = false
        
        let navBarIconHeight = (navigationController?.navigationBar.bounds.size.height)! * 0.7
        let icon = UIImage(named: "futLife-logo-text")
        
        let iconTitleView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: navBarIconHeight, height: navBarIconHeight))
        iconTitleView.image = icon
        iconTitleView.contentMode = .scaleAspectFit
        parent?.navigationItem.titleView = iconTitleView
        parent?.addLeftBarButtonWithImage(UIImage(named: "slidingMenuButton")!)
        
        navigationBar(show: true, backgroundColor: UIColor().darkBlue())
        
        balancelabel.font = UIFont().bebasFont(size: 14)
        balancelabel.text = "SALDO ACTUAL: $0"
        
        getAllChallengeRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func getAllChallengeRequest() {
        let user: UserModel? = LocalDataManager.user!
        if user != nil {
            weak var weakSelf = self            
            ApiManager.getChallenges(userId: (user?.id)!) { (errorModel, challenges) in
                if let strongSelf = weakSelf {
                    if (errorModel?.success)! {
                        strongSelf.getPlayersRequest(user: user!, challenges: challenges)
                    } else {
                        strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError, completion: nil)
                    }
                }
            }
        }
    }
    
    private func getPlayersRequest(user: UserModel, challenges: [Challenges]) {
        weak var weakSelf = self
        ApiManager.getPlayers(userId: user.id) { (errorModel, players) in
            if let strongSelf = weakSelf {
                AppDelegate.hidePKHUD()
                if (errorModel?.success)! {
                    let playersListVC = PlayersListViewController(players: players)
                    let challengesVC = ChallengesViewController(players: players, challenges: challenges)
                    let myChallengesVC = ChallengesViewController(players: players, challenges: [])
                    
                    strongSelf.tabsTitles = ["MIS RETOS", "JUGADORES", "¡ÚNETE!"]
                    strongSelf.tabsViewControllers = [myChallengesVC, playersListVC, challengesVC]
                    
                    strongSelf.showTabDefault = 2
                    strongSelf.reloadTabs()
                } else {
                    strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError, completion: nil)
                }
            }
        }
    }
    
    func hidePlayerOptions() {
        UIView.animate(withDuration: 0.1, animations: {
            var playerOptionsViewFrame = self.playerOptionsView?.frame
            playerOptionsViewFrame?.origin.y = Utils.screenViewFrame().height + 20.0
            self.playerOptionsView?.frame = playerOptionsViewFrame!
        }) { (finished) in
            self.darkBgButton?.fadeOut(duration: 0.3, alpha: 0.0, completion: nil)
        }        
    }
}

extension HomeViewController: PlayerListProtocol {
    func playerOptions(player: User) {
        //homeCompletion = () -> Void?
        let darkBgViewFrame = CGRect(x: 0, y: 0, width: Utils.screenViewFrame().width, height: Utils.screenViewFrame().height)
        darkBgButton = UIButton(frame: darkBgViewFrame)
        darkBgButton?.backgroundColor = UIColor.black
        darkBgButton?.alpha = 0
        darkBgButton?.isUserInteractionEnabled = true
        darkBgButton?.addTarget(self, action: #selector(hidePlayerOptions), for: .touchUpInside)
        darkBgButton?.fadeIn(duration: 0.3, alpha: 0.5, completion: nil)
        
        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(darkBgButton!)
        
        playerOptionsView = Bundle.main.loadNibNamed("PlayerOptionsView", owner: self, options: nil)?.first as? PlayerOptionsView
        playerOptionsView?.delegate = self
        var playerOptionsViewFrame = playerOptionsView?.frame
        playerOptionsViewFrame?.origin.y = Utils.screenViewFrame().height
        playerOptionsViewFrame?.size.width = Utils.screenViewFrame().width
        playerOptionsView?.frame = playerOptionsViewFrame!
        
        playerOptionsView?.setUpView(player: player)
        playerOptionsView?.layoutSubviews()        
        
        currentWindow?.addSubview(playerOptionsView!)
        
        UIView.animate(withDuration: 0.3) {
            var playerOptionsViewFrame = self.playerOptionsView?.frame
            playerOptionsViewFrame?.origin.y = Utils.screenViewFrame().height - (self.playerOptionsView?.frame.height)! + 20.0
            self.playerOptionsView?.frame = playerOptionsViewFrame!
        }
    }
    
    func closePlayerOptionsView() {
        hidePlayerOptions()
    }
}
