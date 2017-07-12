//
//  Constants.swift
//  FutLife
//
//  Created by Rene Santis on 6/18/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let kFormTopScrollPadding: CGFloat = 10.0
    static let kCarouselTransformCellValue = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
    // get base URL set in .plist
    static var baseURLPath: String {
        let dictionary = Bundle.main.infoDictionary!
        let path = dictionary["api.baseUrl"] as! String
        return path
    }
    static let queryURLPath = "/m/v1"
    static let platform = "iOS"
    static let kDidSelectCarouselItemNotification = "DidSelectCarouselItemNotification"
    static let kDefaultAnimationDuration = 0.3
}
