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
    
    static func login(params: Parameters, success: @escaping () -> Void, failure: @escaping (ErrorModel?) -> Void) {
        ApiManager.loginRequest(loginParameters: params) { (error) in
            if error?.success == false {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    static func logOut(closure: @escaping () -> Void) {
        AppDelegate.sharedInstance.removeLocalData()
        SessionDataManager.isLogOut = true
        closure()
    }
}
