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
    static func getParameters(completion: @escaping (Error?) -> Void) {
        Alamofire.request(ApiRouter.parameters).responseObject { (response: DataResponse<ConfigurationParameters>) in            
            let parameters = response.result.value
            
            // Set response to Model constants
            ConfigurationParametersModel.platforms = parameters?.platforms
            ConfigurationParametersModel.consoles = parameters?.consoles
            ConfigurationParametersModel.games = parameters?.games
            
            completion(response.result.error)
        }
    }
    
    // POST: Login
    static func loginRequest(loginParameters: Parameters, completion: @escaping (Error?) -> Void) {
        Alamofire.request(ApiRouter.login(loginParameters: loginParameters)).responseObject { (response: DataResponse<LoginResponse>) in
            let loginResponse = response.result.value
            
            // Set response to Model constants
            LoginModel.token = loginResponse?.token
            LoginModel.success = loginResponse?.success
            LoginModel.data = loginResponse?.data
            
            completion(response.result.error)
        }
    }
}
