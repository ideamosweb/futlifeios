//
//  LoginManager.swift
//  FutLife
//
//  Created by Rene Santis on 6/20/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import Alamofire

struct LoginManager {
    
    static func login(params: Parameters, success: @escaping () -> Void, failure: @escaping (Error?) -> Void) {
        ApiManager.loginRequest(loginParameters: params) { (error) in
            if error != nil {
                failure(error)
            } else {
                success()
            }
        }
    }
}
