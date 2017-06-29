//
//  Array+Utils.swift
//  FutLife
//
//  Created by Rene Santis on 6/27/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
