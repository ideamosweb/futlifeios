//
//  SessionDataManager.swift
//  FutLife
//
//  Created by Rene Santis on 7/2/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

struct SessionDataManager {
    public static var isLogOut: Bool = false
    public static var token: String = ""
    public static var challengeAmount: String = ""
    public static var challengeConsole: NSNumber = 0
    public static var challengeGame: NSNumber = 0
}
