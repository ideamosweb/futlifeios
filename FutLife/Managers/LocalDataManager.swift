//
//  LocalDataManager.swift
//  FutLife
//
//  Created by Rene Santis on 6/28/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

struct LocalDataManager {
    static let kParameters = "Parameters"
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
            return UserDefaults().bool(forKey: kRegisteredUser)
        }
        set (newValue) {
            UserDefaults().set(newValue, forKey: kRegisteredUser)
        }
    }
    
    static var user: User {
        get {
            return UserDefaults().dataObjectForKey(key: kUser) as! User
        }
        set (newValue) {
            UserDefaults().setDataObject(value: newValue, forKey: kUser)
        }
    }
    
    static var avatar: UIImage {
        get {
            return UserDefaults().dataObjectForKey(key: kUserAvatar) as! UIImage
        }
        set (newValue) {
            UserDefaults().setDataObject(value: newValue, forKey: kUserAvatar)
        }
    }
    
    static var chosenConsole: Bool {
        get {
            return UserDefaults().bool(forKey: kChosenConsole)
        }
        set (newValue) {
            UserDefaults().set(newValue, forKey: kChosenConsole)
        }
    }
    
    static var chosenGame: Bool {
        get {
            return UserDefaults().bool(forKey: kChosenGame)
        }
        set (newValue) {
            UserDefaults().set(newValue, forKey: kChosenGame)
        }
    }
    
    static var completedRegister: Bool {
        get {
            return UserDefaults().bool(forKey: kCompletedRegister)
        }
        set (newValue) {
            UserDefaults().set(newValue, forKey: kCompletedRegister)
        }
    }
    
    static var logged: Bool {
        get {
            return UserDefaults().bool(forKey: kLogged)
        }
        set (newValue) {
            UserDefaults().set(newValue, forKey: kLogged)
        }
    }
    
    static var parameters: ConfigurationParametersModel {
        get {
            return UserDefaults().dataObjectForKey(key: kParameters) as! ConfigurationParametersModel
        }
        set (newValue) {
            UserDefaults().setDataObject(value: newValue, forKey: kParameters)
        }
    }
    
    static var consolesSelected: [ConsoleModel] {
        get {
            return UserDefaults().dataObjectForKey(key: kConsoles) as! [ConsoleModel]
        }
        set (newValue) {
            UserDefaults().setDataObject(value: newValue, forKey: kConsoles)
        }
    }
    
    static var gamesSelected: [GameModel] {
        get {
            return UserDefaults().dataObjectForKey(key: kGames) as! [GameModel]
        }
        set (newValue) {
            UserDefaults().setDataObject(value: newValue, forKey: kGames)
        }
    }
    
}
