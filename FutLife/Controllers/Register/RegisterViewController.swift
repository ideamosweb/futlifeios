//
//  RegisterViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/19/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class RegisterViewController: FormViewController {
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var userTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    var registerCompleted: () -> Void?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(registerCompleted: @escaping () -> Void?) {
        self.registerCompleted = registerCompleted
        super.init(nibName: "RegisterViewController", bundle: Bundle.main)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let's pass the fields to inputsFormManager
        inputsFormManager.inputFields = [nameTextField, userTextField, emailTextField, passwordTextField]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar(show: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configTextFields()
    }
    
    private func configTextFields() {
        nameTextField.isRequired = true
        nameTextField.minTypeableLength = 5
        nameTextField.maxTypeableLenght = 20
        let rectTopCorner: UIRectCorner = [.topLeft, .topRight]
        nameTextField.roundedCorners(roundingCorners: rectTopCorner, cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        userTextField.isRequired = true
        userTextField.minTypeableLength = 5
        userTextField.maxTypeableLenght = 20
        
        emailTextField.isRequired = true
        emailTextField.isEmail = true
        
        passwordTextField.isRequired = true
        passwordTextField.isPassword = true
        passwordTextField.minTypeableLength = 6
        passwordTextField.maxTypeableLenght = 20
        let rectBottomCorner: UIRectCorner = [.bottomLeft, .bottomRight]
        passwordTextField.roundedCorners(roundingCorners: rectBottomCorner, cornerRadii: CGSize(width: 10.0, height: 10.0))
    }
    
    @IBAction func onFacebookButtonTouch(_ sender: Any) {
        presentAlert(title: "Error", message: "Funcionalidad en desarrollo", style: .formError)
    }
    
    @IBAction func onRegisterButtonTouch(_ sender: Any) {
        inputsFormManager.currentInputField?.resignFirstResponder()
        
        // Validate input fields form
        weak var weakSelf = self
        inputsFormManager.validateForm(success: {
            if let strongSelf = weakSelf {
                strongSelf.registerUser()
            }
        }) { (errorMessage) in
            presentAlert(title: "Error", message: errorMessage, style: .formError)
        }
    }
    
    private func registerUser() {
        weak var weakSelf = self
        
        // TODO: Move to other side
        let params: Parameters = ["name": nameTextField.text ?? "",
                                  "username": userTextField.text ?? "",
                                  "email": emailTextField.text ?? "",
                                  "password": passwordTextField.text ?? "",
                                  "password_confirmation": passwordTextField.text ?? "",
                                  "platform": Constants.platform]
        
        AppDelegate.showPKHUD()
        ApiManager.registerRequest(registerParameters: params) { (errorModel) in
            AppDelegate.hidePKHUD()
            if let strongSelf = weakSelf {
                if (errorModel?.success)! {
                    strongSelf.registerCompleted()
                } else {
                    strongSelf.presentAlert(title: "Error", message: (errorModel?.message)!, style: alertStyle.formError)
                    
                }
            }            
        }
    }
}
