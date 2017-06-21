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
    case register
    case registerPreferences
    case registerAvatar(String)
    case games
    case consoles
    case login
    case challenges
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
                return "\(Constants.queryURLPath)preferences"
            case .registerAvatar:
                return "\(Constants.queryURLPath)"
            case .games:
                return "\(Constants.queryURLPath)"
            case .consoles:
                return "\(Constants.queryURLPath)"
            case .login:
                return "\(Constants.queryURLPath)"
            case .challenges:
                return "\(Constants.queryURLPath)"
            case .allUsers:
                return "\(Constants.queryURLPath)"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
                case .register(let contentID):
                    return ["content": contentID, "extract_object_colors": 0]
                case .consoles(let contentID):
                    return ["content": contentID, "extract_object_colors": 0]
                case .games(let contentID):
                    return ["content": contentID, "extract_object_colors": 0]
                case .allUsers(let contentID):
                    return ["content": contentID, "extract_object_colors": 0]
                default:
                    return [:]
            }
        }()
        
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        //request.setValue(authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
