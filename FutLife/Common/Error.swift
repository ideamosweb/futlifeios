//
//  Error.swift
//  FutLife
//
//  Created by Rene Santis on 6/19/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum FieldValidationsError: Error {
    case validationRequired
    case validationMinLength
    case validationMaxLength
    case validationFixLength
    case validationSameTextAsOther
    case validationEmail
    case validationEmailNoEmpty
    case validationOnlyNumbers
    case validationUnknownError
    case validationNoError
}

struct ApiError {
    enum ApiErrorCode: Int {
        case badRequest = 400
        case unAuthorized = 401
    }
    
    static func checkError(responseData: Data?, statusCode: Int) -> ErrorModel {
        let error: Int = statusCode
        var errorModel = ErrorModel()
        errorModel.success = true
        
        if error == ApiError.ApiErrorCode.badRequest.rawValue || error == ApiError.ApiErrorCode.unAuthorized.rawValue {
            if let data = responseData {
                let errorStr = String(data: data, encoding: String.Encoding.utf8)!
                let dict = Utils.convertToDictionary(text: errorStr)!
                errorModel.message = dict["message"] as? String ?? dict["error"] as? String
            }
            
            errorModel.success = false
            
            return errorModel
        }
        
        return errorModel
    }
}
