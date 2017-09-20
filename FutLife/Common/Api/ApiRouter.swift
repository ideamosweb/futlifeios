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
    case challenges(userId: String)
    case players(userId: String)
    case allUsers
    case editInformation(userId: String, parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .register, .registerPreferences, .registerAvatar, .login:
                return .post
            case .parameters, .consoles, .games, .allUsers, .challenges, .players:
                return .get
            case .editInformation:
                return .put
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
                return "\(Constants.queryURLPath)/challenge"
            case .players:
                return "\(Constants.queryURLPath)/players"
            case .allUsers:
                return "\(Constants.queryURLPath)"
            case .editInformation:
                return "\(Constants.queryURLPath)/user"
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
        case .challenges(let userId):
            // Override URL for set userId get param
            request.url = URL(string: Constants.baseURLPath + path + "/\(userId)/get")
            request.addValue("Bearer \(LocalDataManager.token!)", forHTTPHeaderField: "Authorization")
        case .players(let userId):
            // Override URL for set userId get param
            request.url = URL(string: Constants.baseURLPath + path + "/\(userId)")
            request.addValue("Bearer \(LocalDataManager.token!)", forHTTPHeaderField: "Authorization")
        case .editInformation(let userId, let parameters):
            // Override URL for set userId get param
            request.url = URL(string: Constants.baseURLPath + path + "/\(userId)/update")
            request = try URLEncoding.default.encode(request, with: parameters)
            request.addValue("Bearer \(LocalDataManager.token!)", forHTTPHeaderField: "Authorization")
        default:
            request = try URLEncoding.default.encode(request, with: [:])
        }
        
        return request
    }
}
