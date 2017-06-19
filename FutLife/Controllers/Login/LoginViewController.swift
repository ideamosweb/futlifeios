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
        passwordTextField.minTypeableLength = 6
        let rectBottomCorner: UIRectCorner = [.bottomLeft, .bottomRight]
        passwordTextField.roundedCorners(roundingCorners: rectBottomCorner, cornerRadii: CGSize(width: 10.0, height: 10.0))
    }
    
    //MARK: Actions methods
    @IBAction func onLoginButtonTouch(_ sender: Any) {
        inputsFormManager.currentInputField?.resignFirstResponder()
        
        // Validate input fields form
        weak var weakSelf = self
        inputsFormManager.validateForm(success: {
            if let strongSelf = weakSelf {
                strongSelf.loginUser()
            }
        }) { (errorMessage) in
            presentAlert(title: "Estimado Jugador", message: errorMessage, style: .formError)
        }
    }
    
    @IBAction func onRegisterButtonTouch(_ sender: Any) {
        presentAlert(title: "Estimado Jugador", message: "Funcionalidad en desarrollo", style: .formError)
    }
    
    @IBAction func onFacebookLoginButtonTouch(_ sender: Any) {
        presentAlert(title: "Estimado Jugador", message: "Funcionalidad en desarrollo", style: .formError)
    }
    
    @IBAction func onforgetPasswordButtonTouch(_ sender: Any) {
        presentAlert(title: "Estimado Jugador", message: "Funcionalidad en desarrollo", style: .formError)
    }
    
    func loginUser() {
        
    }
}
