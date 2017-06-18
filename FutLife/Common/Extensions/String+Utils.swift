//
//  String+Utils.swift
//  FutLife
//
//  Created by Rene Santis on 6/17/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        return validateUsingRegex(regex: emailRegex)
    }
    
    func validateUsingRegex(regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            let match =  results.map { nsString.substring(with: $0.range)}
            if match.count > 0 {
                return true
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
        
        return false
    }
    
    func isNumber() -> Bool {
        return numberValue() as! Bool
    }
    
    func numberValue() -> NSNumber {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        
        let number = fmt.number(from: self)
        return number!
    }
}
