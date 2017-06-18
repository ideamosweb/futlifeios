//
//  FieldValidations.swift
//  FutLife
//
//  Created by Rene Santis on 6/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

enum FieldValidationEnum: Error {
    case validationRequired
    case validationMinLength
    case validationMaxLength
    case validationFixLength
    case validationSameTextAsOther
    case validationEmail
    case validationEmailNoEmpty
    case validationOnlyNumbers
}

struct FieldValidations {
    static func validationRequired(inputText: String?) -> Bool {
        guard let inputTextValid = inputText else {
            return false
        }
        
        if inputTextValid.isEmpty {
            return true
        }
        
        return false
    }
    
    static func validationMinLength(minLength: Int, inputText: String) -> Bool {
        if inputText.characters.count < minLength {
            return true
        }
        
        return false
    }
    
    static func validationMaxLength(maxLength: Int, inputText: String) -> Bool {
        if inputText.characters.count > maxLength {
            return true
        }
        
        return false
    }
    
    static func validationFixedLength(fixedLength: Int, inputText: String) -> Bool {
        return inputText.characters.count == fixedLength
    }
    
    static func validationSameTextAsOtherControl(inputText: String, otherInputText: String) -> Bool {
        return inputText == otherInputText
        
    }
    
    static func validationEmail(inputText: String) -> Bool {
        return inputText.isValidEmail() || inputText.isEmpty
    }
    
    static func validationEmailNoEmpty(inputText: String) -> Bool {
        if !inputText.isEmpty {
            if inputText.isValidEmail() {
                return true
            }
        } else {
            return true
        }
        
        return false
    }
    
    static func validationOnlyNumbers(inputText: String) -> Bool {
        return inputText.isNumber()
    }
}
