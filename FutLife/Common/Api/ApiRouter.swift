//
//  ApiRouter.swift
//  FutLife Swift
//
//  Created by Rene Santis on 5/7/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {   
    
    case parameters
    case register(registerParameters: Parameters)
    case registerPreferences(registerPreferencesParameters: Parameters)
    case registerAvatar(registerAvatar: Parameters)
    case games
    case consoles
    case login(loginParameters: Parameters)
    case challenges(challengesParameters: Parameters)
    case allUsers
    
    var method: HTTPMethod {
        switch self {
            case .register, .registerPreferences, .registerAvatar, .login, .challenges:
                return .post
            case .parameters, .consoles, .games, .allUsers:
                return .get
        }
    }
    
    var path: String {
        switch self {
            case .parameters:
                return "\(Constants.queryURLPath)/parameters"
            case .register:
                return "\(Constants.queryURLPath)/register"
            case .registerPreferences:
                return "\(Constants.queryURLPath)/preferences/create"
            case .registerAvatar:
                return "\(Constants.queryURLPath)/user/avatar"
            case .games:
                return "\(Constants.queryURLPath)"
            case .consoles:
                return "\(Constants.queryURLPath)"
            case .login:
                return "\(Constants.queryURLPath)/login"
            case .challenges:
                return "\(Constants.queryURLPath)"
            case .allUsers:
                return "\(Constants.queryURLPath)"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        switch self {
        case .login(let loginParameters):
            request = try URLEncoding.default.encode(request, with: loginParameters)
        case .register(let registerParameters):
            request = try URLEncoding.default.encode(request, with: registerParameters)
        case .registerPreferences(let registerPreferencesParameters):            
            request.addValue("Bearer \(LocalDataManager.token!)", forHTTPHeaderField: "Authorization")
            request = try URLEncoding.default.encode(request, with: registerPreferencesParameters)
        case .registerAvatar(let registerAvatarParameters):
            request.addValue("Bearer \(LocalDataManager.token!)", forHTTPHeaderField: "Authorization")
            request = try URLEncoding.default.encode(request, with: registerAvatarParameters)
        case .challenges(let challengesParameters):
            request = try URLEncoding.default.encode(request, with: challengesParameters)
        default:
            request = try URLEncoding.default.encode(request, with: [:])
        }
        
        return request
    }
}
