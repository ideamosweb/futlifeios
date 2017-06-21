//
//  RegisterViewController.swift
//  FutLife
//
//  Created by Rene Santis on 6/19/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class RegisterViewController: FormViewController {
    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var userTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    var registerCompleted: (())?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(registerCompleted: ()?) {
        super.init(nibName: "RegisterViewController", bundle: Bundle.main)
        
        self.registerCompleted = registerCompleted
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let's pass the fields to inputsFormManager
        inputsFormManager.inputFields = [nameTextField, userTextField, emailTextField, passwordTextField]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar(show: true)
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
        presentAlert(title: "Estimado Jugador", message: "Funcionalidad en desarrollo", style: .formError)
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
            presentAlert(title: "Estimado Jugador", message: errorMessage, style: .formError)
        }
    }
    
    private func registerUser() {
        presentAlert(title: "Estimado jugador", message: "Funcionalidad en desarrollo", style: alertStyle.formError)
    }
}
