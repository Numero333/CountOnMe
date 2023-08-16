//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {

    let model = CalculatorModel()
    
    func testWhenGiving_2by2_shouldRespond_4() {
        model.addNumber(number: "2")
        model.addOperator(operand: "+")
        model.addNumber(number: "2")
        
        model.calcul()
        
        print(model.currentCalcul)
                
        XCTAssertTrue(model.currentCalcul == "2 + 2 = 4")
    }
}
