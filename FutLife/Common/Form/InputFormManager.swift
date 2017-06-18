//
//  InputFormManager.swift
//  FutLife
//
//  Created by Rene Santis on 6/14/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class InputFormManager: NSObject {
    // Save all the input fields.
    var inputFields: [TextField]?
    // The current input field.
    var currentInputField: UIView?
    
    // Gets the next input field, taking into account disabled input fields.
    var nextInputField: TextField? {
        let currentIndex = inputFields?.index(where: {$0 === currentInputField})
        
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
        let currentIndex = inputFields?.index(where: {$0 === currentInputField})
        
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
    func firstEnableInput() -> UIControl? {
        for inputField: UIControl in inputFields! {
            if inputField is UITextField && inputField.isEnabled {
                return inputField
            }
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
    func validateInputField(inputField: TextField) {
        do {
            try inputField.validate()
        } catch FieldValidationEnum.validationRequired {
            
        } catch FieldValidationEnum.validationMinLength {
            
        } catch FieldValidationEnum.validationMaxLength {
            
        } catch FieldValidationEnum.validationFixLength {
            
        } catch FieldValidationEnum.validationOnlyNumbers {
            
        } catch FieldValidationEnum.validationEmail {
            
        } catch FieldValidationEnum.validationEmailNoEmpty {
            
        } catch FieldValidationEnum.validationSameTextAsOther {
            
        } catch {
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === currentInputField {
            if currentInputField is UITextField {
                currentInputField = nextInputField
                
                let view: UIView = object as! UIView
                if view.isFirstResponder {
                    currentInputField?.becomeFirstResponder()
                }
            }
        }
    }
    
    

}
