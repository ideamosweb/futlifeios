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
            
            if let strongSelf = weakSelf {
                if (error?.success)! {
                    // Go to time line if is logged or register completed
                    if LocalDataManager.completedRegister || LocalDataManager.logged {
                        strongSelf.goToHome()                        
                    } else {
                        // Hide spinner PKHUD when not go to home (this is for avoid bug)
                        AppDelegate.hidePKHUD()
                        strongSelf.checkLoginOrRegister()
                    }
                } else {
                    // Hide spinner PKHUD when not go to home (this is for avoid bug)
                    AppDelegate.hidePKHUD()
                    strongSelf.presentAlert(title: "Error", message: (error?.message)!, style: alertStyle.formError, completion: nil)
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
                let registerVC = prepareRegisterVC()
                AppDelegate.mainNavigationController.pushViewController(registerVC, animated: false)
                
                goToChooseConsole(navBar: true)
            } else if !LocalDataManager.chosenGame {
                let chooseConsoleVC = prepareChooseConsoleVC(navBar: true)
                AppDelegate.mainNavigationController.pushViewController(chooseConsoleVC, animated: false)
                
                goToChooseGame(navBar: true)
            } else if !LocalDataManager.completedRegister {
                let chooseGameVC = prepareChooseGameVC(navBar: true)
                AppDelegate.mainNavigationController.pushViewController(chooseGameVC, animated: false)
                
                goToUserProfile(navBar: false, confirmButton: true)
            } else {
                goToHome()
            }
        }
    }
    
    private func prepareLoginVC() -> LoginViewController {
        weak var weakSelf = self
        let loginVC = LoginViewController(registerClosure: { () in
            // Go to Register
            if let strongSelf = weakSelf {
                strongSelf.goToRegister()
            }
        }, loginClosure: { () in
            // Go to dashboard!!
            if let strongSelf = weakSelf {
                strongSelf.goToHome()
            }
        }, chooseConsoleClosure: { () in
            // Go to chooseConsole
            if let strongSelf = weakSelf {
                LocalDataManager.registeredUser = true
                strongSelf.goToChooseConsole(navBar: true)
            }
        })
        
        return loginVC
    }
    
    private func goToLogin() {
        let loginVC = prepareLoginVC()
        
        AppDelegate.mainNavigationController.pushViewController(loginVC, animated: false)
    }
    
    private func prepareRegisterVC() -> RegisterViewController {
        weak var weakSelf = self
        let registerVC = RegisterViewController { () in
            if let strongSelf = weakSelf {
                LocalDataManager.registeredUser = true
                strongSelf.goToChooseConsole(navBar: true)
            }
        }
        
        return registerVC
    }
    
    private func goToRegister() {
        let registerVC = prepareRegisterVC()
        
        AppDelegate.mainNavigationController.pushViewController(registerVC, animated: true)
    }
    
    private func prepareChooseConsoleVC(navBar: Bool) -> ChooseConsoleViewController {
        weak var weakSelf = self
        let chooseConsoleVC = ChooseConsoleViewController(navBar: navBar) { (consoles) in
            if let strongSelf = weakSelf {
                LocalDataManager.chosenConsole = true
                strongSelf.goToChooseGame(navBar: true)
            }
        }
        
        return chooseConsoleVC
    }
    
    private func goToChooseConsole(navBar: Bool) {
        let chooseConsoleVC = prepareChooseConsoleVC(navBar: navBar)
        
        AppDelegate.mainNavigationController.pushViewController(chooseConsoleVC, animated: true)
    }
    
    private func prepareChooseGameVC(navBar: Bool) -> ChooseGameViewController {
        weak var weakSelf = self
        let chooseGameVC = ChooseGameViewController(navBar: navBar) { (games) in
            if let strongSelf = weakSelf {
                LocalDataManager.chosenGame = true
                strongSelf.goToUserProfile(navBar: true, confirmButton: true)
            }
        }
        
        return chooseGameVC
    }
    
    private func goToChooseGame(navBar: Bool) {
        let chooseGameVC = prepareChooseGameVC(navBar: navBar)
        
        AppDelegate.mainNavigationController.pushViewController(chooseGameVC, animated: true)
    }
    
    private func goToUserProfile(navBar: Bool, confirmButton: Bool) {
        weak var weakSelf = self
        let profileVC = ProfileViewController(navBar: navBar, confirmButton: confirmButton) {
            if let strongSelf = weakSelf {
                LocalDataManager.completedRegister = true
                strongSelf.showSuccessMessage()
            }
        }
        
        AppDelegate.mainNavigationController.pushViewController(profileVC, animated: true)
    }
    
    private func goToHome() {
        let homeVC = HomeViewController(completion: nil)
        
        AppDelegate.sharedInstance.goToHome(homeViewController: homeVC)
    }
    
    private func showSuccessMessage() {
        let alertController = UIAlertController(title: "¡Felicitaciones!", message: "El registro ha sido exitoso, bienvenido a Futlife.", preferredStyle: UIAlertControllerStyle.alert)
        
        weak var weakSelf = self
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            if let strongSelf = weakSelf {
                AppDelegate.showPKHUD()
                strongSelf.goToHome()
            }
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
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
