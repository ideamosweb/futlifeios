//
//  LoginViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/18/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class LoginViewController: FormViewController {
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var registerClosure: (())?
    var loginClosure: (())?
    var chooseConsoleClosure: (())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(registerClosure: (), loginClosure: (), chooseConsoleClosure: ()) {
        super.init(nibName: "LoginViewController", bundle: Bundle.main)
        
        self.registerClosure = registerClosure
        self.loginClosure = loginClosure
        self.chooseConsoleClosure = chooseConsoleClosure
    }

    override func viewDidLoad() {
        super.viewDidLoad()       
        
        // Let's pass the fields to inputsFormManager
        inputsFormManager.inputFields = [usernameTextField, passwordTextField]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configTextFields()
    }
    
    private func configTextFields() {
        usernameTextField.isRequired = true
        usernameTextField.minTypeableLength = 5
        usernameTextField.maxTypeableLenght = 20
        let rectTopCorner: UIRectCorner = [.topLeft, .topRight]
        usernameTextField.roundedCorners(roundingCorners: rectTopCorner, cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        passwordTextField.isRequired = true
        passwordTextField.isPassword = true
        let rectBottomCorner: UIRectCorner = [.bottomLeft, .bottomRight]
        passwordTextField.roundedCorners(roundingCorners: rectBottomCorner, cornerRadii: CGSize(width: 10.0, height: 10.0))
    }
}
