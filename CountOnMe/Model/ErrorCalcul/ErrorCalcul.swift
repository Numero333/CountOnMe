//
//  ErrorCalcul.swift
//  CountOnMe
//
//  Created by François-Xavier on 09/08/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum ErrorCalcul: Error {
    case divisionByZero
    case invalidInput
    case alreadyHaveResult
    case alreadyHaveOperator
    case notEnoughtElement
    case unknowError
}
