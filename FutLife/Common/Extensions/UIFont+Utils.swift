//
//  UIFont+Utils.swift
//  FutLife
//
//  Created by Rene Santis on 6/27/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    func bebasFont(size: CGFloat) -> UIFont {
        return UIFont(name: "BebasNeueRegular", size: size)!
    }
    
    func bebasBoldFont(size: CGFloat) -> UIFont {
        return (UIFont(name: "BebasNeueBold", size: size))!
    }
    
    func bebasLightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "BebasNeueLight", size: size)!
    }
}
