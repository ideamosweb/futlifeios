//
//  HomeViewController.swift
//  FutLife
//
//  Created by Rene Santis on 8/7/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class HomeViewController: TabsViewController {
    var users: [UserModel] = []
    var darkBackgroundButton: UIButton = UIButton()
    var homeCompletion: () -> Void?
    
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
        
        getAllChallengeRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar(show: true)
        navigationController?.navigationBar.barTintColor = UIColor().darkBlue()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func onMenuButtonTouch() {
        self.slideMenuController()?.openLeft()
    }
    
    private func getAllChallengeRequest() {
        let user: UserModel? = LocalDataManager.user!
        if user != nil {
            weak var weakSelf = self
            AppDelegate.showPKHUD()
            ApiManager.getChallenges(userId: (user?.id)!) { (errorModel) in
                if let strongSelf = weakSelf {
                    if (errorModel?.success)! {
                        AppDelegate.showPKHUD()
                        strongSelf.getPlayersRequest(user: user!)
                    } else {
                        strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError)
                    }
                }
            }
        }
    }
    
    private func getPlayersRequest(user: UserModel) {
        weak var weakSelf = self
        AppDelegate.showPKHUD()        
        ApiManager.getPlayers(userId: user.id) { (errorModel, players) in
            AppDelegate.hidePKHUD()
            if let strongSelf = weakSelf {
                if (errorModel?.success)! {
                    let playersListVC = PlayersListViewController(players: players)
                    
                    strongSelf.tabsTitles = ["Jugadores", "Pendientes"]
                    strongSelf.tabsViewControllers = [playersListVC, ViewController()]
                    
                    strongSelf.reloadTabs()
                } else {
                    strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError)
                }
            }
        }
    }
}
