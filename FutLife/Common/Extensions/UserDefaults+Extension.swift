//
//  UserDefaults+Extension.swift
//  FutLife
//
//  Created by Rene Santis on 6/28/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

extension UserDefaults {
    func stringForKey(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func objectForKey(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    func setObject(value: Any, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    func dataObjectForKey(key: String) -> Any? {
        if let dataObject: Data = UserDefaults.standard.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: dataObject) as Any
        }
        return nil
    }
    
    func setDataObject(value: Any?, forKey: String) {
        if let val = value {
            let encodedObject = NSKeyedArchiver.archivedData(withRootObject: val)
            
            UserDefaults.standard.set(encodedObject, forKey: forKey)
        } else {
            remove(key: forKey)
        }        
    }
    
    func remove(key: String) {
        let prefs = UserDefaults.standard        
        prefs.removeObject(forKey:key)
    }
}
