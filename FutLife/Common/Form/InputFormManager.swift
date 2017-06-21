//
//  InputFormManager.swift
//  FutLife
//
//  Created by Rene Santis on 6/14/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class InputFormManager: NSObject {
    static let kFormManagerEnabledTexFieldKeyPath  = "enabled"    
    
    var didOnce = false
    // Save all the input fields.
    var inputFields: [TextField]?
    // The current input field.
    var currentInputField: UIView?
    
    // Gets the next input field, taking into account disabled input fields.
    var nextInputField: TextField? {
        let currentIndex = inputFields?.index(where: {$0 == currentInputField})
        
        var nextInputIndex = (currentIndex! + 1) % (inputFields?.count)!
        while nextInputIndex != currentIndex {
            let nextField = inputFields?[nextInputIndex]
            if nextField != nil && (nextField?.isEnabled)! {
                return nextField!
            }
            
            nextInputIndex = (nextInputIndex + 1) % (inputFields?.count)!
        }
        
        return nil
    }
    
    // Gets the previous input field, taking into account disabled input fields.
    var previousInputField: UIControl? {
        let currentIndex = inputFields?.index(where: {$0 == currentInputField})
        
        var previousInputIndex = (currentIndex! - 1) % (inputFields?.count)!
        while previousInputIndex != currentIndex {
            let previousField = inputFields?[previousInputIndex]
            if previousField != nil && (previousField?.isEnabled)! {
                return previousField!
            }
            
            previousInputIndex = (previousInputIndex - 1) % (inputFields?.count)!
        }
        
        return nil
    }
    
    override init() {
        super.init()
        // ...
    }
    
    // Gets the first enabled input within the form.
    func firstEnableInput() -> TextField? {
        for inputField in inputFields! {
            return inputField
        }
        
        return nil
    }
    
    // Gets the last enabled input within the form.
    func lastEnabledInput() -> UIControl? {
        var lastIndex = (inputFields?.count)! - 1
        while lastIndex != -1 {
            let inputField: UIControl = (inputFields?[lastIndex])!
            if inputField is UITextField && inputField.isEnabled {
                return inputField
            }
            
            lastIndex -= 1
        }
        
        return nil
    }
    
    /* TODO: move to other place (?) */
    func validateInputField(inputField: TextField) -> TextFieldValidationError {
        // return error message
        return FieldValidations.validateInputTextField(inputField: inputField)
    }
    
    // Observe value for input TextField
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Move to the next input field (if any), if the current input field
        // is getting disabled.
        if !didOnce {
            if object as AnyObject? === currentInputField {
                if currentInputField is UITextField {
                    let field = currentInputField as! UITextField
                    if field.isEnabled == false {
                        currentInputField = nextInputField
                        
                        let view: UIView = object as! UIView
                        if view.isFirstResponder {
                            currentInputField?.becomeFirstResponder()
                        }
                    }
                    
                    didOnce = true
                }
            }
        }
        
    }
    
    deinit {
        if didOnce {
            for inputField in inputFields! {
                inputField.removeObserver(self, forKeyPath: InputFormManager.kFormManagerEnabledTexFieldKeyPath)
            }
        }        
    }
    
    //MARK: Public Methods
    func setInputFields(fieldsToAdd: [TextField]) {
        guard var fields = inputFields else {
            return
        }
        
        for inputField in fields {
            inputField.removeObserver(self, forKeyPath: InputFormManager.kFormManagerEnabledTexFieldKeyPath)
        }
        
        fields = fieldsToAdd
        
        for fieldToAdd in fieldsToAdd {
            fieldToAdd.addObserver(self, forKeyPath: InputFormManager.kFormManagerEnabledTexFieldKeyPath, options: NSKeyValueObservingOptions.new, context: nil)
        }
        
        currentInputField?.reloadInputViews()
    }
    
    // Send the first and last field by completion block for set the scrollView contentSize
    func firstAndLastInputFieldsClosure(closure: (TextField, TextField) -> Void) {
        if (inputFields?.count)! > 0 {
            let firstInputField = inputFields?.first
            let lastInputField = inputFields?.last
            
            closure(firstInputField!, lastInputField!)
        }
    }
    
    func validateForm(success: () -> Void, failure: (String) -> Void) {
        currentInputField?.resignFirstResponder()
        var isFailed = false
        var validationError: TextFieldValidationError?
        for inputField in inputFields! {
            validationError = validateInputField(inputField: inputField)
            if (validationError?.validationErrorEnum != FieldValidationsError.validationNoError) {
                isFailed = true
                failure((validationError?.errorMessage)!)
                return
            }
        }
        
        if isFailed == false {
            validationError = nil
            validationError?.criteria = nil
            validationError?.errorMessage = nil
            validationError?.validationErrorEnum = nil
            success()
        }
    }
}
