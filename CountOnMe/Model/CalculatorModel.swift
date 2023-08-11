//
//  CalculatorModel.swift
//  CountOnMe
//
//  Created by François-Xavier on 22/07/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

final class Calculator {
    
    //MARK: - Property
    weak var delegate: CalculatorDelegate?
    
    //MARK: Accessible
    func calcul(for elements: [String]) {
        
        if !expressionHaveEnoughElement(elements: elements)  {
            delegate?.didFail(error: .invalidInput)
            return
        }
        
        if expressionHaveResult(elements: elements) {
            delegate?.didFail(error: .alreadyHaveResult)
            return
        }
        
        if !expressionIsCorrect(elements: elements) {
            delegate?.didFail(error: .invalidInput)
            return
        }
        
        var operationsToReduce = cleanExpression(elements: elements)
               
        //Calcul first multiplication and division
        performOnlyMultiplyOrDivisionOperations(for: &operationsToReduce)
        // Calcul soustraction and addition
        performOnlyAdditionOrSoustractionOperations(for: &operationsToReduce)
        
        guard let returnValue = operationsToReduce.first else {
            //TODO: to test
            delegate?.didPerformCalculation(result: "\(operationsToReduce)")
            return }
        
        delegate?.didPerformCalculation(result: " = \(returnValue)")
    }
    
    func addOperator(for elements: [String], operand: String) {
        if canAddOperator(elements: elements, for: operand) {
            delegate?.addOperator(operand: operand)
        } else {
            delegate?.didFail(error: .alreadyHaveOperator)
        }
    }
    
    func addNumber(for elements: [String], number: String) {
        if expressionHaveResult(elements: elements) {
            delegate?.didFail(error: .alreadyHaveResult)
        } else {
            delegate?.addNumber(number: number)
        }
    }
    
    //MARK: - Private
    private func expressionIsCorrect(elements: [String]) -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "x"
    }
    
    private func expressionHaveEnoughElement(elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    private func canAddOperator(elements: [String], for operand: String) -> Bool {
        //TODO: refact ?
        if elements.first == nil && (operand == "x" || operand == "/") {
            return false
        }
        
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "x"
    }
    
    private func expressionHaveResult(elements: [String]) -> Bool {
        return elements.firstIndex(of: "=") != nil
    }
    
    private func performOperation(left: Double, operatorSymbol: String, right: Double) -> Double {
        switch operatorSymbol {
        case "+": return left + right
        case "-": return left - right
        case "/":
            if left == 0 || right == 0 {
                delegate?.didFail(error: .divisionByZero)
                return 0
            } else {
                return left / right
            }
        case "x": return left * right
        default: delegate?.didFail(error: .invalidInput)
            return 0
        }
    }
    
    private func performOnlyMultiplyOrDivisionOperations(for operations: inout [String]) {
        while operations.contains("x") || operations.contains("/") {
            if let index = operations.firstIndex(where: { $0 == "x" || $0 == "/" }) {
                guard let leftOperand = Double(operations[index - 1]),
                      let rightOperand = Double(operations[index + 1]) else {
                    delegate?.didFail(error: .unknowError)
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
    
    private func performOnlyAdditionOrSoustractionOperations(for operations: inout [String]) {
        while operations.count > 1 {
            guard let left = Double(operations[0]) else { return }
            let operatorSymbol = operations[1]
            guard let right = Double(operations[2]) else { return }
            
            let result = performOperation(left: left, operatorSymbol: operatorSymbol, right: right)
            
            operations[0] = "\(result)"
            operations.remove(at: 1)
            operations.remove(at: 1)
        }
    }
    
    private func cleanExpression(elements: [String]) -> [String] {
        var data = elements
        
        //        Check first element
                if data[0] == "-" {
                    
                    let value = data[1]
                    data.remove(at: 1)
                    data[0] = "-\(value)"
                    
                } else if data[0] == "+" {
                    data.remove(at: 0)
                }
        return data
    }
}
