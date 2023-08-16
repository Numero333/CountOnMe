//
//  CalculatorModelTests.swift
//  CountOnMeTests
//
//  Created by François-Xavier on 04/08/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorModelTests: XCTestCase, CalculatorModelDelegate {
    // MARK: - Property
    
    private let calculator = CalculatorModel()
    
    // MARK: - Override
    
    override func setUp() {
        calculator.delegate = self
    }

    // MARK: - Tests
    
    func testAddtion() {
        calculator.addNumber(number: "5")
        calculator.addOperator(operand: "+")
        calculator.addNumber(number: "5")
        calculator.calcul()
        XCTAssert(true)
    }
    
    // MARK: - CalculatorModelDelegate
    
    func didUpdate(calcul: String) {
        print(calcul)
    }
    
    func didFail(error: CountOnMe.ErrorCalcul) {
        //
    }
}
