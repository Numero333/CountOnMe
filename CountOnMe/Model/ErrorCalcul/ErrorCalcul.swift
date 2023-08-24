//
//  ErrorCalcul.swift
//  CountOnMe
//
//  Created by François-Xavier on 16/08/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum ErrorCalcul: Error {
    case divisionByZero
    case invalidInput
    case alreadyHaveResult
    case operatorError
    case notEnoughtElement
    
    var content: String {
        switch self {
        case .divisionByZero: return "Division by zero is impossible"
        case .invalidInput: return "There is a problem with the input data"
        case .alreadyHaveResult: return "Please start a new calculation"
        case .operatorError: return "You cannot add this operator here"
        case .notEnoughtElement: return "There are not enough elements to perform a calculation"
        }
    }
}
