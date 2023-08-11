//
//  CalculatorDelegate.swift
//  CountOnMe
//
//  Created by François-Xavier on 09/08/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorDelegate: AnyObject {
    func didPerformCalculation(result: String)
    func didFail(error: ErrorCalcul)
    func addOperator(operand: String)
    func addNumber(number: String)
}
