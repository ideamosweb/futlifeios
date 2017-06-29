//
//  FLStartUpViewController.swift
//  FutLife Swift
//
//  Created by Rene Santis on 3/10/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class StartUpViewController: ViewController {
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var background: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: "StartUpViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNavigationBar(show: false)

        setVersionLabel()
        getParameters()
    }
    
    func animationLogo() {
        
    }
    
    func setVersionLabel() {
        let currentAppVersion = Bundle.appVersion()
        versionLabel.text = currentAppVersion
    }
    
    func getParameters() {
        weak var weakSelf = self
        ApiManager.getParameters { (error) in
            if let strongSelf = weakSelf {
                if (error?.success)! {
                    strongSelf.goToLogin()
                } else {
                    strongSelf.presentAlert(title: "Error", message: (error?.message)!, style: alertStyle.formError)
                    
                }
            }            
        }
    }
    
    func goToLogin() {
        let loginVC = LoginViewController(registerClosure: { () -> Void? in
            self.goToRegister()
        }, loginClosure: { () -> Void? in
            print("")
        }, chooseConsoleClosure: { () -> Void? in
            print("")
        })
        
        AppDelegate.mainNavigationController.pushViewController(loginVC, animated: false)
    }
    
    func goToRegister() {
        let registerVC = RegisterViewController { () -> Void? in
            print("")
        }
        
        AppDelegate.mainNavigationController.pushViewController(registerVC, animated: false)
    }
}

extension Bundle {
    static func appVersion() -> String {
        guard let bundleShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else {
            return "0.0"
        }
        
        return bundleShortVersion as! String
    }
}
