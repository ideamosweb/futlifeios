//
//  CitiesProtocol.swift
//  FutLife
//
//  Created by Rene Alberto Santis Vargas on 9/20/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

protocol CitiesProtocol {
    var cities: [City]? { get }
    var citySelected: City? { get }
}
