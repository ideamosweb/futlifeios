//
//  Utils.swift
//  FutLife
//
//  Created by Rene Santis on 6/16/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import UIKit

class Utils: NSObject {
    class func addBorderColor(view: UIView, color: UIColor, roundSize: CGFloat, stroke: CGFloat) {
        view.layer.cornerRadius = roundSize
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = stroke
        view.clipsToBounds = true
    }

}
