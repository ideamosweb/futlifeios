//
//  UIColor+Extension.swift
//  FutLife
//
//  Created by Rene Santis on 8/6/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    func darkBlue() -> UIColor {
        return UIColor.init(red: 2.0/255, green: 14.0/255, blue: 25.0/255, alpha: 1.0)
    }
    
    func greenDefault() -> UIColor {
        return UIColor.init(red: 85.0/255, green: 164.0/255, blue: 36.0/255, alpha: 1.0)
    }
    
    func lightGray() -> UIColor {
        return UIColor.init(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1.0)
    }
    
    func orange() -> UIColor {
        return UIColor.init(red: 246.0/255, green: 192.0/255, blue: 0.0/255, alpha: 1.0)
    }
    
    func red() -> UIColor {
        return UIColor.init(red: 190.0/255, green: 61.0/255, blue: 58.0/255, alpha: 1.0)
    }
}
