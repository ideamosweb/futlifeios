//
//  LocalDataManager.swift
//  FutLife
//
//  Created by Rene Santis on 6/28/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

struct LocalDataManager {
    static let kRegisteredUser = "RegisteredUser"
    static let kUser = "User"
    static let kUserAvatar = "Avatar";
    static let kChosenConsole = "ChosenConsole";
    static let kChosenGame = "ChosenGame";
    static let kCompletedRegister = "CompletedRegister";
    static let kLogged = "Logged";
    static let kConsoles = "Consoles";
    static let kAllConsoles = "AllConsoles";
    static let kGames = "Games";
    static let kAllGames = "AllGames";
    static let kSessionToken = "SessionToken";
    
    init() { }
    
    static var registeredUser: Bool {
        get {
            return UserDefaults().objectForKey(key: kRegisteredUser) as! Bool
        }
        set {
            UserDefaults().setObject(value: NSNumber.init(booleanLiteral: registeredUser), forKey: kRegisteredUser)
        }
    }
    
    static var user: User {
        get {
            return UserDefaults().dataObjectForKey(key: kUser) as! User
        }
        set {
            UserDefaults().setDataObject(value: user, forKey: kUser)
        }
    }
    
    static var avatar: UIImage {
        get {
            return UserDefaults().dataObjectForKey(key: kUserAvatar) as! UIImage
        }
        set {
            UserDefaults().setDataObject(value: avatar, forKey: kUserAvatar)
        }
    }
    
    static var chosenConsole: Bool {
        get {
            return UserDefaults().objectForKey(key: kChosenConsole) as! Bool
        }
        set {
            UserDefaults().setObject(value: chosenConsole, forKey: kChosenConsole)
        }
    }
    
    static var chosenGame: Bool {
        get {
            return UserDefaults().objectForKey(key: kChosenGame) as! Bool
        }
        set {
            UserDefaults().setObject(value: chosenGame, forKey: kChosenGame)
        }
    }
    
    static var completedRegister: Bool {
        get {
            return UserDefaults().objectForKey(key: kCompletedRegister) as! Bool
        }
        set {
            UserDefaults().setObject(value: completedRegister, forKey: kCompletedRegister)
        }
    }
    
    static var logged: Bool {
        get {
            return UserDefaults().objectForKey(key: kLogged) as! Bool
        }
        set {
            UserDefaults().setObject(value: logged, forKey: kLogged)
        }
    }
    
}
