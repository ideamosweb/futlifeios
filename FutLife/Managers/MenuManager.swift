//
//  MenuManager.swift
//  FutLife
//
//  Created by Rene Santis on 8/23/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

class MenuManager: NSObject {
    static var menuItemDefinition: Dictionary = MenuManager.loadMenuItemDefinitions()
    static var currentViewController: ViewController?
    
    override init() { }
    
    static func loadMenuItemDefinitions() -> Dictionary<String, Any> {
        // Read menu items definition from .plist
        var menuDefinitions: Dictionary<String, Any>?
        if let fileUrl = Bundle.main.url(forResource: "MenuItemsDefinitions", withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? Dictionary<String, Any> {
                menuDefinitions = result!
            }
            
        }
        
        return menuDefinitions!
    }
    
    func onProfileTouch(player: UserModel) {
        MenuManager.currentViewController = nil
        if MenuManager.currentViewController == nil {
            let nav = AppDelegate.mainNavigationController
            MenuManager.currentViewController = ProfilePlayerViewController(player: LocalDataManager.user!, type: .GamesType, profileCompleted: nil)
            AppDelegate().closeLeftMenu()
            nav.pushViewController(MenuManager.currentViewController!, animated: true)
        }
    }
    
    func onTopUpTouch(_ sender: Any) {
        
    }
    
    func onCashOutTouch(_ sender: Any) {
        
    }
    
    func onChallengesOverTouch(_ sender: Any) {
        
    }
    
    func onChallengesReportedTouch(_ sender: Any) {
        
    }
    
    func onIntroductionTouch(_ sender: Any) {
        
    }
    
    func onSettingsTouch(_ sender: Any) {
        
    }
    
    func onSuggestionTouch(_ sender: Any) {
        
    }
    
    func onWhoTouch(_ sender: Any) {
        
    }
    
    func onLogOutTouch(_ sender: Any) {
        LoginManager.logOut {
            AppDelegate.sharedInstance.openStartUp()
        }
    }
}
