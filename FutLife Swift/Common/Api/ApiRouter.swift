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
    // get base URL set in .plist
    var baseURLPath: String {
        let dictionary = Bundle.main.infoDictionary!
        let path = dictionary["api.baseUrl"] as! String
        return path
    }
    
    // authentication token from .plist
    var authenticationToken: String {
        let dictionary = Bundle.main.infoDictionary!
        let token = dictionary["api.authentication.token"] as! String
        return token
    }
    
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
                return "/parameters"
            case .register:
                return "/register"
            case .registerPreferences:
                return "preferences"
            case .registerAvatar:
                return ""
            case .games:
                return ""
            case .consoles:
                return ""
            case .login:
                return ""
            case .challenges:
                return ""
            case .allUsers:
                return ""
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
        
        let url = try baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
