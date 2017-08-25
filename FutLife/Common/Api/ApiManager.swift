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
    public static func uploadAvatarRequest(registerAvatarParameters: Parameters, imageData: Data, completion: @escaping (ErrorModel?) -> Void) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            
            for (key, value) in registerAvatarParameters {
                multipartFormData.append((value as! String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
            }            
        }, to:"\(Constants.queryURLPath)/user/avatar")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    //print response.result
                    // Verify if exist an error an return a message
                    let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (200))
                    completion(errorModel)
                }
                
            case .failure( _):
                let errorModel: ErrorModel = ApiError.checkError(responseData: nil, statusCode: (500))
                completion(errorModel)
            }
        }
    }
    
    // POST: Create user
    public static func createUser(createUserParameters: Parameters, completion: @escaping (ErrorModel?) -> Void) {
        Alamofire.request(ApiRouter.registerPreferences(registerPreferencesParameters: createUserParameters)).responseObject { (response: DataResponse<RegisterCreateResponse>) in
            
            // Verify if exist an error an return a message
            let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (response.response?.statusCode)!)
            
            completion(errorModel)
        }
    }
    
    // GET: Challenges
    static func getChallenges(userId: Int, completion: @escaping (ErrorModel?, _ challenges: [Challenges]) -> Void) {
        Alamofire.request(ApiRouter.challenges(userId: "\(userId)")).responseObject { (response: DataResponse<ChallengesResponse>) in
            let challenges = response.result.value
            
            // Verify if exist an error an return a message
            let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (response.response?.statusCode)!)
            if errorModel.success! {
                // Set response to Model constants
                ChallengesModel.data = challenges?.data
                ChallengesModel.success = challenges?.success
            }
            
            completion(errorModel, (challenges?.data)!)
        }
    }
    
    // GET: Players
    static func getPlayers(userId: Int, completion: @escaping (ErrorModel?, _ players: [User]) -> Void) {
        Alamofire.request(ApiRouter.players(userId: "\(userId)")).responseObject { (response: DataResponse<PlayersResponse>) in
            let players = response.result.value
            
            // Verify if exist an error an return a message
            let errorModel: ErrorModel = ApiError.checkError(responseData: response.data, statusCode: (response.response?.statusCode)!)
            if errorModel.success! {
                // Set response to Model constants
                PlayersModel.data = players?.data
                PlayersModel.success = players?.success
            }
            
            completion(errorModel, (players?.data)!)
        }
    }
}
