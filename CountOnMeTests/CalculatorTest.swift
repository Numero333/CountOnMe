//
//  CalculatorTest.swift
//  CountOnMeTests
//
//  Created by François-Xavier on 21/08/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorTest: XCTestCase {
    
    var model: CalculatorModel!
    
    var delegate: MockCalculatorModelDelegate!
    
    override func setUp() {
        model = CalculatorModel()
        delegate = MockCalculatorModelDelegate()
        model.delegate = delegate
    }
    
    func testAdddition() {
        // Given
        model.addOperator(Operator.addition)
        model.addNumber("5")
        model.addOperator(Operator.addition)
        model.addNumber("5")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.resultat == " + 5 + 5 = 10")
    }
    
    func testSubtraction() {
        // Given
        model.addOperator(Operator.subtraction)
        model.addNumber("5")
        model.addOperator(Operator.subtraction)
        model.addNumber("5")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.resultat == " - 5 - 5 = -10")
    }
    
    func testDivision() {
        // Given
        model.addNumber("2")
        model.addOperator(Operator.division)
        model.addNumber("2")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.resultat == "2 / 2 = 1")
    }
    
    func testDivisionByZero() {
        // Given
        model.addNumber("2")
        model.addOperator(Operator.division)
        model.addNumber("0")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.error == .divisionByZero)
    }
    
    func testMultiplication() {
        // Given
        model.addOperator(Operator.subtraction)
        model.addNumber("5")
        model.addOperator(Operator.multiplication)
        model.addNumber("5")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.resultat == " - 5 x 5 = -25")
    }
    
    func testInvalidOperator() {
        // Given
        model.addNumber("2")
        model.addOperator("%")
        model.addNumber("2")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.error == .invalidInput)
    }
    
    func testValueIsNotNumber() {
        // Given
        model.addNumber("e")
        model.addOperator(Operator.multiplication)
        model.addNumber("2")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.error == .invalidInput)
        
        model.clear()
        
        // Given
        model.addNumber("2")
        model.addOperator(Operator.multiplication)
        model.addNumber("e")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.error == .invalidInput)
    }
    
    func testNotEnoughElement() {
        // Given
        model.addNumber("5")
        model.addOperator(Operator.subtraction)
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.error == .notEnoughtElement)
    }
    
    func testAlreadyHaveResult() {
        // Given
        model.addOperator(Operator.subtraction)
        model.addNumber("5")
        model.addOperator("-")
        model.addNumber("5")
        // When
        model.calcul()
        model.calcul()
        // Then
        XCTAssert(delegate.error == .alreadyHaveResult)
    }
    
    func testExpresdsionIsCorrect() {
        // Given
        model.addOperator(Operator.subtraction)
        model.addNumber("5")
        model.addOperator(Operator.multiplication)
        model.addOperator(Operator.subtraction)
        model.addNumber("5")
        model.addOperator(Operator.multiplication)
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.error == .invalidInput)
    }
    
    func testAddOperatorWithResult() {
        // Given
        model.addNumber("5")
        model.addOperator(Operator.multiplication)
        model.addNumber("5")
        // When
        model.calcul()
        model.addOperator(Operator.addition)
        // Then
        XCTAssert(delegate.error == .alreadyHaveResult)
    }
    
    func testAddOperatorWithOperator() {
        
        // Given
        model.addNumber("5")
        model.addOperator(Operator.multiplication)
        model.addNumber("5")
        model.addOperator(Operator.subtraction)
        // When
        model.addOperator(Operator.multiplication)
        // Then
        XCTAssert(delegate.error == .operatorError)
    }
    
    func testWrongAddOperatorFirst() {
        // Given
        model.addOperator(Operator.multiplication)
        model.addNumber("5")
        model.addOperator(Operator.subtraction)
        model.addNumber("3")
        // When
        model.calcul()
        // Then
        XCTAssert(delegate.error == .operatorError)
    }
    
    func testAddNumber() {
        // Given
        model.addOperator(Operator.subtraction)
        model.addNumber("5")
        model.addOperator(Operator.multiplication)
        model.addNumber("5")
        // When
        model.calcul()
        model.addNumber("9")
        // Then
        XCTAssert(delegate.error == .alreadyHaveResult)
    }
    
    func testClear() {
        // Given
        model.addNumber("5")
        // When
        model.clear()
        // Then
        XCTAssert(delegate.resultat == "")
    }
}

class MockCalculatorModelDelegate: CalculatorModelDelegate {
    
    var resultat: String?
    var error: ErrorCalcul?
    
    func didFail(error: CountOnMe.ErrorCalcul) {
        self.error = error
    }

    func didUpdate(calcul: String) {
        self.resultat = calcul
    }
}
