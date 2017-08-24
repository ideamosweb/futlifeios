//
//  MenuManager.swift
//  FutLife
//
//  Created by Rene Santis on 8/23/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

struct MenuManager {
    static var menuItemDefinition: Dictionary = MenuManager.loadMenuItemDefinitions()
    
    static var currentViewController: ViewController?
    
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
    
    static func onProfileTouch(_ sender: Any, player: User) {
        
    }
    
    static func onTopUpTouch(_ sender: Any) {
        
    }
    
    static func onCashOutTouch(_ sender: Any) {
        
    }
    
    static func onChallengesOverTouch(_ sender: Any) {
        
    }
    
    static func onChallengesReportedTouch(_ sender: Any) {
        
    }
    
    static func onIntroductionTouch(_ sender: Any) {
        
    }
    
    static func onSettingsTouch(_ sender: Any) {
        
    }
    
    static func onSuggestionTouch(_ sender: Any) {
        
    }
    
    static func onWhoTouch(_ sender: Any) {
        
    }
    
    static func onLogOutTouch(_ sender: Any) {
        
    }
}
