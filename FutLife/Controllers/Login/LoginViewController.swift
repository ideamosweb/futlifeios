//
//  LoginViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/18/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: FormViewController {
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var registerClosure: () -> Void?
    var loginClosure: () -> Void?
    var chooseConsoleClosure: () -> Void?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(registerClosure: @escaping () -> Void?, loginClosure: @escaping () -> Void?, chooseConsoleClosure: @escaping () -> Void?) {
        self.registerClosure = registerClosure
        self.loginClosure = loginClosure
        self.chooseConsoleClosure = chooseConsoleClosure
        
        super.init(nibName: "LoginViewController", bundle: Bundle.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let's pass the fields to inputsFormManager
        inputsFormManager.inputFields = [usernameTextField, passwordTextField]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar(show: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configTextFields()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = UIColor.red
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
            presentAlert(title: "Error", message: errorMessage, style: .formError)
        }
    }
    
    @IBAction func onRegisterButtonTouch(_ sender: Any) {
        let registerController = RegisterViewController(registerCompleted: {() in
            self.chooseConsoleClosure()
        })
        
        //let consoleVC = ChooseConsoleViewController(navBar: true, chooseConsoleCompleted: ())
        
        navigationController?.pushViewController(registerController, animated: true)
    }
    
    @IBAction func onFacebookLoginButtonTouch(_ sender: Any) {
        presentAlert(title: "Estimado Jugador", message: "Funcionalidad en desarrollo", style: .formError)
    }
    
    @IBAction func onforgetPasswordButtonTouch(_ sender: Any) {
        presentAlert(title: "Estimado Jugador", message: "Funcionalidad en desarrollo", style: .formError)
    }
    
    func loginUser() {
        weak var weakSelf = self
        
        // TODO: Move to other side
        let params: Parameters = ["username": usernameTextField.text ?? "",
                                  "password": passwordTextField.text ?? ""]
        
        AppDelegate.showPKHUD()
        LoginManager.login(params: params, success: {
            AppDelegate.hidePKHUD()
            print("Login success")
        }) { (error) in
            AppDelegate.hidePKHUD()
            if let strongSelf = weakSelf {
                strongSelf.presentAlert(title: "Error", message: (error?.message)!, style: alertStyle.formError)
            }
        }
    }
}
