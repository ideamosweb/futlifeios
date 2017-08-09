//
//  FLStartUpViewController.swift
//  FutLife Swift
//
//  Created by Rene Santis on 3/10/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import PKHUD

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
        
        navigationBar(show: false)
        
        // Control login behaviour
        if !SessionDataManager.isLogOut {
            setVersionLabel()
            animationLogo()
        } else {
            goToLogin()
        }
        
    }
    
    private func setVersionLabel() {
        let currentAppVersion = Bundle.appVersion()
        versionLabel.text = currentAppVersion
    }
    
    private func animationLogo() {
        logoImageView.animateLogo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.getParameters()
        }
    }
    
    private func getParameters() {
        weak var weakSelf = self
        AppDelegate.showPKHUD()
        ApiManager.getParameters { (error) in
            AppDelegate.hidePKHUD()
            if let strongSelf = weakSelf {
                if (error?.success)! {
                    // Go to time line if is logged or register completed
                    if LocalDataManager.completedRegister || LocalDataManager.logged {
                        strongSelf.goToHome()
                    } else {
                        strongSelf.checkLoginOrRegister()
                    }
                } else {
                    strongSelf.presentAlert(title: "Error", message: (error?.message)!, style: alertStyle.formError)
                    
                }
            }            
        }
    }
    
    private func checkLoginOrRegister() {
        if !LocalDataManager.registeredUser {
            goToLogin()
        } else {
            if !LocalDataManager.registeredUser {
                goToLogin()
            } else if !LocalDataManager.chosenConsole {
                goToChooseConsole(navBar: false)
            } else if !LocalDataManager.chosenGame {
                goToChooseGame(navBar: false)
            } else if !LocalDataManager.completedRegister {
                goToUserProfile(navBar: false, confirmButton: true)
                //goToChooseConsole(navBar: false)
            } else {
                goToHome()
            }
        }
    }
    
    private func goToLogin() {
        weak var weakSelf = self
        let loginVC = LoginViewController(registerClosure: { () -> Void? in
            // Go to Register
            if let strongSelf = weakSelf {
                strongSelf.goToRegister()
            }
            
            return ()
        }, loginClosure: { () -> Void? in
            // Go to dashboard!!
            if let strongSelf = weakSelf {
                strongSelf.goToHome()
            }
            
            return ()
        }, chooseConsoleClosure: { () -> Void? in
            // Go to chooseConsole
            if let strongSelf = weakSelf {
                LocalDataManager.registeredUser = true
                strongSelf.goToChooseConsole(navBar: true)
            }
            
            return ()
        })
        
        AppDelegate.mainNavigationController.pushViewController(loginVC, animated: false)
    }
    
    private func goToRegister() {
        weak var weakSelf = self
        let registerVC = RegisterViewController { () -> Void? in
            if let strongSelf = weakSelf {
                LocalDataManager.registeredUser = true
                strongSelf.goToChooseConsole(navBar: true)
            }
            
            return ()
        }
        
        AppDelegate.mainNavigationController.pushViewController(registerVC, animated: true)
    }
    
    private func goToChooseConsole(navBar: Bool) {
        weak var weakSelf = self
        let chooseConsoleVC = ChooseConsoleViewController(navBar: navBar, chooseConsoleCompleted: { (consoles) -> Void? in
            if let strongSelf = weakSelf {
                LocalDataManager.chosenConsole = true
                strongSelf.goToChooseGame(navBar: true)
            }
            
            return ()
        })
        
        AppDelegate.mainNavigationController.pushViewController(chooseConsoleVC, animated: true)
    }
    
    private func goToChooseGame(navBar: Bool) {
        weak var weakSelf = self
        let chooseGameVC = ChooseGameViewController(navBar: navBar) { (games) -> Void? in
            if let strongSelf = weakSelf {
                LocalDataManager.chosenGame = true
                strongSelf.goToUserProfile(navBar: true, confirmButton: true)
            }
            
            return ()
        }
        
        AppDelegate.mainNavigationController.pushViewController(chooseGameVC, animated: true)
    }
    
    private func goToUserProfile(navBar: Bool, confirmButton: Bool) {
        weak var weakSelf = self
        let profileVC = ProfileViewController(navBar: navBar, confirmButton: confirmButton) {
            if let strongSelf = weakSelf {
                LocalDataManager.completedRegister = true
                strongSelf.goToHome()
            }
            
            return ()
        }
        
        AppDelegate.mainNavigationController.pushViewController(profileVC, animated: true)
    }
    
    private func goToHome() {
        let homeVC = HomeViewController { () -> Void? in
            return ()
        }
        
        AppDelegate.sharedInstance.goToHome(homeViewController: homeVC)
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
