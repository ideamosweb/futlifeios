//
//  TextField.swift
//  FutLife
//
//  Created by Rene Santis on 6/16/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class TextField: UITextField, CitiesProtocol {
    
    // Validation properties
    var isRequired = false
    var validationError = false
    var maxTypeableLenght: Int?
    var minTypeableLength: Int?
    var fixedLength: Int?
    var isEmail = false
    var isOnlyNumbers = false
    var autoCompleteTable: UITableView?
    private var _autoCompleteOptions: [City]?
    
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
    
    var isAutoCompleted: Bool {
        get {
            return self.isAutoCompleted
        }
        
        set {
            if newValue {
                addAutoCompleteTable()
            }
        }
    }
    
    override var text: String? {
        didSet {
            beforeTextValidation = text
        }
    }
    
    var cities: [City]? {
        get {
            if let options = _autoCompleteOptions {
                return options
            }
            
            return []
        }
        
        set {
            _autoCompleteOptions = newValue
            if let tableView = autoCompleteTable {
                tableView.isHidden = false
                tableView.reloadData()
            }
        }
    }
    
    var citySelected: City?
    
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
            if FieldValidations.validationRequired(inputField: self) {
                throw FieldValidationsError.validationRequired
            }
        }
        
        if maxTypeableLenght != nil && maxTypeableLenght! > 0 {
            if FieldValidations.validationMaxLength(maxLength: maxTypeableLenght!, inputField: self) {
                throw FieldValidationsError.validationMaxLength
            }
        }
        
        if minTypeableLength != nil && minTypeableLength! > 0 {
            if FieldValidations.validationMinLength(minLength: minTypeableLength!, inputField: self) {
                throw FieldValidationsError.validationMinLength
            }
        }
        
        if fixedLength != nil && fixedLength! > 0 {
            if FieldValidations.validationFixedLength(fixedLength: fixedLength!, inputField: self) {
                throw FieldValidationsError.validationFixLength
            }
        }
        
        if isEmail {
            if FieldValidations.validationEmail(inputField: self) {
                throw FieldValidationsError.validationEmail
            }
        }
        
        if isOnlyNumbers {
            if FieldValidations.validationOnlyNumbers(inputField: self) {
                throw FieldValidationsError.validationOnlyNumbers
            }
        }
        
        if FieldValidations.validationNoError() {
            throw FieldValidationsError.validationNoError
        }       
    }
    
    private func addAutoCompleteTable() {
        let tableViewFrame = CGRect(x: self.frame.maxX - 200, y: self.frame.minY - 10, width: 200, height: 55)
        
        autoCompleteTable = UITableView(frame: tableViewFrame)
        autoCompleteTable?.delegate = self
        autoCompleteTable?.dataSource = self
        autoCompleteTable?.isHidden = true
        autoCompleteTable?.isUserInteractionEnabled = true
        autoCompleteTable?.layer.borderWidth = 1.0
        autoCompleteTable?.layer.borderColor = UIColor.lightGray.cgColor
        
        self.superview?.addSubview(autoCompleteTable!)
        self.superview?.bringSubview(toFront: autoCompleteTable!)
    }
    
    func hideAutoCompleteTable() {
        cities = []
        autoCompleteTable?.isHidden = true
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

extension TextField: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option: City = (cities?[indexPath.row])!
        self.text = ""
        self.text = option.name
        citySelected = option
        
        hideAutoCompleteTable()
    }
}

extension TextField: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (cities?.count)! > 0 {
            return cities!.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let option = cities?[indexPath.row]
        
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font = UIFont().bebasFont(size: 18.0)
        cell.textLabel?.text = option?.name
        
        cell.isUserInteractionEnabled = true
        
        return cell
    }
}
