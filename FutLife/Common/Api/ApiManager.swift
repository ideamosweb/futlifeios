//
//  ApiManager.swift
//  FutLife
//
//  Created by Rene Santis on 5/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class ApiManager {
    
    // GET: Parameters
    static func getParameters(completion: @escaping (ErrorModel?) -> Void) {
        Alamofire.request(ApiRouter.parameters).responseObject { (response: DataResponse<ConfigurationParameters>) in            
            let parameters = response.result.value
            
            // Verify if exist an error an return a message
            let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (response.response?.statusCode)!)
            if errorModel.success! {
                // Set response to Model constants
                ConfigurationParametersModel.platforms = parameters?.platforms
                ConfigurationParametersModel.consoles = parameters?.consoles
                ConfigurationParametersModel.games = parameters?.games
            }
            
            completion(errorModel)
        }
    }
    
    // POST: Login
    static func loginRequest(loginParameters: Parameters, completion: @escaping (ErrorModel?) -> Void) {
        Alamofire.request(ApiRouter.login(loginParameters: loginParameters)).responseObject { (response: DataResponse<LoginResponse>) in
            let loginResponse = response.result.value
            
            // Verify if exist an error an return a message
            let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (response.response?.statusCode)!)
            if errorModel.success! {
                // Set response to Model constants
                LoginModel.token = loginResponse?.token
                LoginModel.success = loginResponse?.success
                LoginModel.data = loginResponse?.data
            }
            
            completion(errorModel)
        }
    }
    
    // POST: Register
    public static func registerRequest(registerParameters: Parameters, completion: @escaping (ErrorModel?) -> Void) {
        Alamofire.request(ApiRouter.register(registerParameters: registerParameters)).responseObject { (response: DataResponse<RegisterResponse>) in
            let loginResponse = response.result.value
            
            // Verify if exist an error an return a message
            let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (response.response?.statusCode)!)
            if errorModel.success! {
                // Set response to Model constants
                RegisterModel.token = loginResponse?.token
                RegisterModel.success = loginResponse?.success
                RegisterModel.data = loginResponse?.data
            }
            
            completion(errorModel)
        }
    }
}
