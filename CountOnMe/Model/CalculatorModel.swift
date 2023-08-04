//
//  CalculatorModel.swift
//  CountOnMe
//
//  Created by François-Xavier on 22/07/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

final class Calculator {
    
    
    //MARK: - Property
    var textView : UITextView
    
    private var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") == nil
    }
    
    //MARK: - Initialization
    init(textView: UITextView) {
        self.textView = textView
    }
    
    //MARK: Accessible
    func makeCalcul() {
        var operationsToReduce = elements
        
        //Calcul first multiplication and division
        performMultiplyOrDivisionOperations(for: &operationsToReduce)
        
        // Calcul soustraction and addition
        performAdditionOrSoustraction(for: &operationsToReduce)
        
        self.textView.text.append(" = \(operationsToReduce.first!)")
        print(textView.text ?? "no info")
    }
    
    //MARK: - Private
    private func performOperation(left: Int, operatorSymbol: String, right: Int) -> Int {
        switch operatorSymbol {
        case "+": return left + right
        case "-": return left - right
        case "/": return left / right
        case "x": return left * right
        default: fatalError("Unknown operator!")
        }
    }
    
    private func performMultiplyOrDivisionOperations(for operations: inout [String]) {
        while operations.contains("x") || operations.contains("/") {
            if let index = operations.firstIndex(where: { $0 == "x" || $0 == "/" }) {
                guard let leftOperand = Int(operations[index - 1]),
                      let rightOperand = Int(operations[index + 1]) else {
                    // Delegate didFailWhilePerformingMultiplicationOrDivisionCalculations
                    return
                }
                
                let operatorSymbol = operations[index]
                let result = performOperation(left: leftOperand, operatorSymbol: operatorSymbol, right: rightOperand)
                
                operations[index - 1] = "\(result)"
                operations.remove(at: index)
                operations.remove(at: index)
            }
        }
    }
    
    private func performAdditionOrSoustraction(for operations: inout [String]) {
        while operations.count > 1 {
            let left = Int(operations[0])!
            let operatorSymbol = operations[1]
            let right = Int(operations[2])!
            
            let result = performOperation(left: left, operatorSymbol: operatorSymbol, right: right)
            
            operations[0] = "\(result)"
            operations.remove(at: 1)
            operations.remove(at: 1)
        }
    }
}
