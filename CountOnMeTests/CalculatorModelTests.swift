//
//  CalculatorModelTests.swift
//  CountOnMeTests
//
//  Created by François-Xavier on 04/08/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class CalculatorModelTests: XCTestCase {

    let calculator = Calculator()
    
    func testWhen(){
        calculator.calcul(for: ["2","+","3"])
    }
    
    
}
