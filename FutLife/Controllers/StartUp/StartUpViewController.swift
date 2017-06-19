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
        //getParameters()
        goToLogin()
    }
    
    func animationLogo() {
        
    }
    
    func setVersionLabel() {
        let currentAppVersion = Bundle.appVersion()
        versionLabel.text = currentAppVersion
    }
    
    func getParameters() {
        ApiManager.getParameters { (parameter, error) in
            if error != nil {
                
            }
        }
    }
    
    func goToLogin() {
        let loginVC = LoginViewController(registerClosure: (), loginClosure: (), chooseConsoleClosure: ())
        AppDelegate.mainNavigationController.pushViewController(loginVC, animated: true)
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
