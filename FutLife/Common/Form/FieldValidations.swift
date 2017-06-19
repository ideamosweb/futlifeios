//
//  FieldValidations.swift
//  FutLife
//
//  Created by Rene Santis on 6/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit
class GetTextFieldValidationError {
    static var textFieldValidationError: TextFieldValidationError?
    init(error: TextFieldValidationError) {
        GetTextFieldValidationError.textFieldValidationError = error
    }
}

struct TextFieldValidationError {
    var criteria: Int?
    var errorMessage: String?
    var validationErrorEnum: FieldValidationsError?
}

struct FieldValidations {
    static func validationRequired(inputField: TextField?) -> Bool {
        guard let inputTextValid = inputField else {
            return false
        }
        
        if (inputTextValid.text?.isEmpty)! {
            var textFieldValidationError = TextFieldValidationError()
            textFieldValidationError.errorMessage = "El campo \(inputField?.placeholder! ?? "") es requerido"
            textFieldValidationError.validationErrorEnum = FieldValidationsError.validationRequired
            
            GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
            return true
        }
        
        return false
    }
    
    static func validationMinLength(minLength: Int, inputField: TextField?) -> Bool {
        if (inputField?.text?.characters.count)! < minLength {
            var textFieldValidationError = TextFieldValidationError()
            textFieldValidationError.criteria = minLength
            textFieldValidationError.errorMessage = "El campo \(inputField?.placeholder! ?? "") tiene un minimo número de caracteres es \(minLength)"
            textFieldValidationError.validationErrorEnum = FieldValidationsError.validationMinLength
            
            GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
            return true
        }
        
        return false
    }
    
    static func validationMaxLength(maxLength: Int, inputField: TextField?) -> Bool {
        if (inputField?.text?.characters.count)! > maxLength {
            var textFieldValidationError = TextFieldValidationError()
            textFieldValidationError.criteria = maxLength
            textFieldValidationError.errorMessage = "El campo \(inputField?.placeholder! ?? "") tiene un máximo número de caracteres es \(maxLength)"
            textFieldValidationError.validationErrorEnum = FieldValidationsError.validationMaxLength
            
            GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
            return true
        }
        
        return false
    }
    
    static func validationFixedLength(fixedLength: Int, inputField: TextField?) -> Bool {
        var textFieldValidationError = TextFieldValidationError()
        textFieldValidationError.criteria = fixedLength
        textFieldValidationError.errorMessage = "El campo \(inputField?.placeholder! ?? "") número de caracteres es \(fixedLength)"
        textFieldValidationError.validationErrorEnum = FieldValidationsError.validationFixLength
        
        GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
        return inputField?.text?.characters.count == fixedLength
    }
    
    static func validationSameTextAsOtherControl(inputText: String, otherInputText: String) -> Bool {
        var textFieldValidationError = TextFieldValidationError()
        textFieldValidationError.errorMessage = "El valor de los campos no concuerdan"
        textFieldValidationError.validationErrorEnum = FieldValidationsError.validationSameTextAsOther
        
        GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
        return inputText == otherInputText
        
    }
    
    static func validationEmail(inputField: TextField?) -> Bool {
        var textFieldValidationError = TextFieldValidationError()
        textFieldValidationError.errorMessage = "El campo \(inputField?.placeholder! ?? "") no es valido"
        textFieldValidationError.validationErrorEnum = FieldValidationsError.validationEmail
        
        GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
        return (inputField?.text?.isValidEmail())! || (inputField?.text?.isEmpty)!
    }
    
    static func validationEmailNoEmpty(inputField: TextField?) -> Bool {
        if inputField?.text?.isEmpty == false {
            if (inputField?.text?.isValidEmail())! {
                var textFieldValidationError = TextFieldValidationError()
                textFieldValidationError.errorMessage = "El campo \(inputField?.placeholder! ?? "") no es valido"
                textFieldValidationError.validationErrorEnum = FieldValidationsError.validationEmailNoEmpty
                
                GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
                return true
            }
        } else {
            var textFieldValidationError = TextFieldValidationError()
            textFieldValidationError.errorMessage = "El campo \(inputField?.placeholder! ?? "") es requerido"
            textFieldValidationError.validationErrorEnum = FieldValidationsError.validationRequired
            
            GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
            return true
        }
        
        return false
    }
    
    static func validationOnlyNumbers(inputField: TextField?) -> Bool {
        var textFieldValidationError = TextFieldValidationError()
        textFieldValidationError.errorMessage = "El campo \(inputField?.placeholder! ?? "") no es númerico"
        textFieldValidationError.validationErrorEnum = FieldValidationsError.validationOnlyNumbers
        
        GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
        return (inputField?.text?.isNumber())!
    }
    
    static func validationNoError() -> Bool {
        var textFieldValidationError = TextFieldValidationError()
        textFieldValidationError.errorMessage = nil
        textFieldValidationError.validationErrorEnum = FieldValidationsError.validationNoError
        
        GetTextFieldValidationError.textFieldValidationError = textFieldValidationError
        
        return textFieldValidationError.validationErrorEnum == FieldValidationsError.validationNoError
    }
    
    static func validateInputTextField(inputField: TextField) -> TextFieldValidationError {
        /*TODO: Set text to another place, (Error class?) */
        do {
            try inputField.validate()
        } catch FieldValidationsError.validationRequired {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        } catch FieldValidationsError.validationMinLength {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        } catch FieldValidationsError.validationMaxLength {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        } catch FieldValidationsError.validationFixLength {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        } catch FieldValidationsError.validationOnlyNumbers {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        } catch FieldValidationsError.validationEmail {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        } catch FieldValidationsError.validationEmailNoEmpty {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        } catch FieldValidationsError.validationSameTextAsOther {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        } catch {
            let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
            return textFieldValidationError!
        }
        
        let textFieldValidationError = GetTextFieldValidationError.textFieldValidationError
        return textFieldValidationError!        
    }
}
