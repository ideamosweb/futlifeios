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
        navigationItem.titleView = iconTitleView
        
        addLeftBarButtonWithImage(UIImage(named: "slidingMenuButton")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar(show: true)
        navigationController?.navigationBar.barTintColor = UIColor().darkBlue()
        navigationController?.navigationBar.isTranslucent = false
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
                AppDelegate.hidePKHUD()
                if let strongSelf = weakSelf {
                    if (errorModel?.success)! {
                        //strongSelf.profileCompleted()
                    } else {
                        strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError)
                    }
                }
            }
        }
    }
}
