//
//  UserDefaults+Extension.swift
//  FutLife
//
//  Created by Rene Santis on 6/28/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

extension UserDefaults {
    func stringForKey(key: String) -> String {
        return UserDefaults.standard.string(forKey: key)!
    }
    
    func objectForKey(key: String) -> Any {
        return UserDefaults.standard.object(forKey: key)!
    }
    
    func setObject(value: Any, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    func dataObjectForKey(key: String) -> Any {
        let dataObject: Data = UserDefaults.standard.object(forKey: key) as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: dataObject) as Any
    }
    
    func setDataObject(value: Any, forKey: String) {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: value)
        
        UserDefaults.standard.setObject(value: encodedObject, forKey: forKey)
    }    
}
