//
//  CalculatorModelTest.swift
//  CountOnMeTests
//
//  Created by François-Xavier on 03/08/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorModelTest: XCTestCase {

    let calculator = Calculator()

    
    func testWhenGivenTwoMultiplyBy10ShouldBe20() {
        let result = calculator.performOperation(left: 2, operatorSymbol: "x", right: 10)
        XCTAssertEqual(result == 20)
    }
}
