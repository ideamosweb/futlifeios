//
//  Error.swift
//  FutLife
//
//  Created by Rene Santis on 6/19/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

import Foundation

enum FieldValidationsError: Error {
    case validationRequired
    case validationMinLength
    case validationMaxLength
    case validationFixLength
    case validationSameTextAsOther
    case validationEmail
    case validationEmailNoEmpty
    case validationOnlyNumbers
    case validationUnknownError
    case validationNoError
}
