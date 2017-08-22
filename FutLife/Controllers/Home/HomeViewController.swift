//
//  HomeViewController.swift
//  FutLife
//
//  Created by Rene Santis on 8/7/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class HomeViewController: TabsViewController {
    @IBOutlet weak var balancelabel: UILabel!
    var users: [UserModel] = []
    var darkBackgroundButton: UIButton = UIButton()
    var homeCompletion: () -> Void?
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
        
        let menuButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 17.0))
        menuButton.setImage(UIImage(named: "slidingMenuButton"), for: .normal)
        menuButton.addTarget(self, action: #selector(onMenuButtonTouch), for: .touchUpInside)
        menuButton.accessibilityIdentifier = "Side_Menu_Button"
        
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        
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
            DispatchQueue.main.async {
                AppDelegate.showPKHUD()
            }            
            ApiManager.getChallenges(userId: (user?.id)!) { (errorModel, challenges) in
                if let strongSelf = weakSelf {
                    if (errorModel?.success)! {
                        strongSelf.getPlayersRequest(user: user!, challenges: challenges)
                    } else {
                        strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError)
                    }
                }
            }
        }
    }
    
    private func getPlayersRequest(user: UserModel, challenges: [Challenges]) {
        weak var weakSelf = self
        ApiManager.getPlayers(userId: user.id) { (errorModel, players) in
            AppDelegate.hidePKHUD()
            if let strongSelf = weakSelf {
                if (errorModel?.success)! {
                    let playersListVC = PlayersListViewController(players: players)
                    let challengesVC = ChallengesViewController(players: players, challenges: challenges)
                    
                    strongSelf.tabsTitles = ["MIS RETOS", "JUGADORES", "¡ÚNETE!"]
                    strongSelf.tabsViewControllers = [ViewController(), playersListVC, challengesVC]
                    
                    strongSelf.showTabDefault = 2
                    strongSelf.reloadTabs()
                } else {
                    strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError)
                }
            }
        }
    }
    
    func onMenuButtonTouch() {
        self.slideMenuController()?.openLeft()
    }
}
