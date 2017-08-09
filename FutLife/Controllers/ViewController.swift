//
//  ViewController.swift
//  FutLife Swift
//
//  Created by Rene Santis on 3/10/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func navigationBar(show: Bool) {
        let mainNavigationController = AppDelegate.mainNavigationController
        if show {
            mainNavigationController.isNavigationBarHidden = false
            mainNavigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            mainNavigationController.navigationBar.shadowImage = UIImage()
            mainNavigationController.navigationBar.isTranslucent = true
            mainNavigationController.view.backgroundColor = UIColor.clear
            mainNavigationController.navigationBar.backgroundColor = UIColor.clear
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.barTintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            
            if mainNavigationController.viewControllers.count > 1 {
                addBackButton()
            } else {
                hideBackButton()
            }
        } else {
            mainNavigationController.isNavigationBarHidden = true
        }
    }
    
    private func addBackButton() {
        let backButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 12.5, height: 23.0))
        backButton.setImage(UIImage(named: "NavigationBarBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(onBackButtonTouch), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
    
    //MARK: Public methods
    func onBackButtonTouch() {
        navigationController?.popViewController(animated: true)
    }    
}

