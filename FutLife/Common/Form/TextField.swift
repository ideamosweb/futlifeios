//
//  TextField.swift
//  FutLife
//
//  Created by Rene Santis on 6/16/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    // Validation properties
    var isRequired = false
    var validationError = false
    var maxTypeableLenght: Int?
    var minTypeableLength: Int?
    var fixedLength: Int?
    var isEmail = false
    var isOnlyNumbers = false
    
    var beforeTextValidation: String?
    
    var typeable = true
    var isPassword: Bool {
        get {
            return isSecureTextEntry
        }
        
        set {
            isSecureTextEntry = true
        }
    }
    
    override var text: String? {
        didSet {
            beforeTextValidation = text
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpTextField()
    }
    
    private func setUpTextField() {
        contentVerticalAlignment = .center
        
        let textFieldDidChange = Notification.Name("textFieldDidChange")
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: textFieldDidChange, object: nil)
        
        let keyboardWillShow = Notification.Name("UIKeyboardWillShow")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: keyboardWillShow, object: nil)
        
        Utils.addBorderColor(view: self, color: UIColor.lightGray, roundSize: 5.0, stroke: 1.0)
    }
    
    func roundedCorners(roundingCorners: UIRectCorner, cornerRadii: CGSize) {
        layoutIfNeeded()
        
        let textFieldMaskLayer = CAShapeLayer()
        let textFieldMaskPathWithRadius = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerRadii)
        
        textFieldMaskLayer.frame = self.bounds
        textFieldMaskLayer.path = textFieldMaskPathWithRadius.cgPath
        textFieldMaskLayer.fillColor = UIColor.white.cgColor
        
        layer.mask = textFieldMaskLayer
    }
    
    func textFieldDidChange(notification: NotificationCenter) {
        // Nothing to do
    }
    
    func keyboardWillAppear(notification: NotificationCenter) {
        if isEditing {
            validationError = false
        }
    }
    
    deinit {
        let keyboardWillShow = Notification.Name("UIKeyboardWillShow")
        NotificationCenter.default.removeObserver(self, name: keyboardWillShow, object: nil)
        
        let textFieldDidChange = Notification.Name("textFieldDidChange")
        NotificationCenter.default.removeObserver(self, name: textFieldDidChange, object: nil)
    }
    

    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        validationError = false
        
        guard let beforeText = beforeTextValidation else {
            return false
        }
        
        if (beforeText.isEmpty == false) {
            text = beforeTextValidation
            beforeTextValidation = nil
        }
        
        return true
    }
    
    // Validate function throws an exception in case a validation was set and it was true
    func validate() throws {
        if isRequired {
            if FieldValidations.validationRequired(inputText: self.text) {
                throw FieldValidationEnum.validationRequired
            }
        }
        
        if maxTypeableLenght != nil && maxTypeableLenght! > 0 {
            if FieldValidations.validationMaxLength(maxLength: maxTypeableLenght!, inputText: self.text!) {
                throw FieldValidationEnum.validationMaxLength
            }
        }
        
        if minTypeableLength != nil && minTypeableLength! > 0 {
            if FieldValidations.validationMinLength(minLength: minTypeableLength!, inputText: self.text!) {
                throw FieldValidationEnum.validationMinLength
            }
        }
        
        if fixedLength != nil && fixedLength! > 0 {
            if FieldValidations.validationFixedLength(fixedLength: fixedLength!, inputText: self.text!) {
                throw FieldValidationEnum.validationFixLength
            }
        }
        
        if isEmail {
            if FieldValidations.validationEmail(inputText: self.text!) {
                throw FieldValidationEnum.validationEmail
            }
        }
        
        if isOnlyNumbers {
            if FieldValidations.validationOnlyNumbers(inputText: self.text!) {
                throw FieldValidationEnum.validationOnlyNumbers
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 0.0
        layer.borderWidth = 0.0
        
        // Custom border
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: frame.size.height - 1, width: frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(bottomBorder)
        
        // Padding left
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
