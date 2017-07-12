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
                
                let user: User = (loginResponse?.data)!
                let userModel: UserModel = UserModel(id: user.id, name: user.name, userName: user.userName, email: user.email, avatar: user.avatar, thumbnail: user.thumbnail, social: user.social, active: user.active, createdAt: user.createdAt, updatedAt: user.updatedAt, cityName: user.cityName)
                LocalDataManager.user = userModel
                LocalDataManager.token = RegisterModel.token
            }
            
            completion(errorModel)
        }
    }
    
    // POST: Upload avatar
    public static func uploadAvatarRequest(registerAvatarParameters: Parameters, completion: @escaping (ErrorModel?) -> Void) {
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(imageData, withName: "avatar", fileName: "avatar.png", mimeType: "image/png")
//        }, to: URLConvertible, encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?)
        
        Alamofire.request(ApiRouter.registerAvatar(registerAvatar: registerAvatarParameters)).responseObject { (response: DataResponse<RegisterAvatar>) in
            let avatarResponse = response.result.value
            
            // Verify if exist an error an return a message
            let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (response.response?.statusCode)!)
            if errorModel.success! {
                // Set response to Model constants
                RegisterAvatarModel.token = avatarResponse?.token
                RegisterAvatarModel.success = avatarResponse?.success
                RegisterAvatarModel.message = avatarResponse?.message
                RegisterAvatarModel.avatar = avatarResponse?.avatar
                RegisterAvatarModel.thumbnail = avatarResponse?.thumbnail
            }
            
            completion(errorModel)
        }
    }
    
    // POST: Register
    public static func createUser(createUserParameters: Parameters, completion: @escaping (ErrorModel?) -> Void) {
        
        
        Alamofire.request(ApiRouter.registerPreferences(registerPreferencesParameters: createUserParameters)).responseObject { (response: DataResponse<RegisterCreateResponse>) in
            //let registerResponse = response.result.value
            
            // Verify if exist an error an return a message
            let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (response.response?.statusCode)!)
            if errorModel.success! {
                // Set response to Model constants
//                RegisterModel.token = loginResponse?.token
//                RegisterModel.success = loginResponse?.success
//                RegisterModel.data = loginResponse?.data
//                
//                let user: User = (loginResponse?.data)!
//                let userModel: UserModel = UserModel(id: user.id, name: user.name, userName: user.userName, email: user.email, avatar: user.avatar, thumbnail: user.thumbnail, social: user.social, active: user.active, createdAt: user.createdAt, updatedAt: user.updatedAt, cityName: user.cityName)
//                LocalDataManager.user = userModel
            }
            
            completion(errorModel)
        }
    }
}
