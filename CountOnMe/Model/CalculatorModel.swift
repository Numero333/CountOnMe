//
//  CalculatorModel.swift
//  CountOnMe
//
//  Created by François-Xavier on 22/07/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

protocol CalculatorModelDelegate: AnyObject {
    func didFail(error: ErrorCalcul)
    func didUpdate(calcul: String)
}

final class CalculatorModel {
    
    //MARK: - Property
    
    private var currentCalcul = "" {
        didSet {
            self.delegate?.didUpdate(calcul: self.currentCalcul)
        }
    }
    
    private var elements: [String] {
        return self.currentCalcul.split(separator: " ").map { "\($0)" }
    }
    
    //MARK: Accessible
    
    weak var delegate: CalculatorModelDelegate?
    
    func calcul() {
        
        if !expressionHaveEnoughElement(elements: self.elements)  {
            delegate?.didFail(error: .notEnoughtElement)
            return
        }
        
        if expressionHaveResult(elements: self.elements) {
            delegate?.didFail(error: .alreadyHaveResult)
            return
        }
        
        if !expressionIsCorrect(elements: self.elements) {
            delegate?.didFail(error: .invalidInput)
            return
        }
        
        var operationsToReduce = cleanExpression(elements: self.elements)
        
        //Calcul first multiplication and division
        performOnlyMultiplicationOrDivisionOperations(for: &operationsToReduce)
        // Calcul soustraction and addition
        performOnlyAdditionOrSubstractionOperations(for: &operationsToReduce)
        
        guard var returnValue = operationsToReduce.first else {
            //TODO: to test
            delegate?.didUpdate(calcul: "\(operationsToReduce)")
            return }
        
        formatDecimal(for: &returnValue)
        
        currentCalcul += " " + Operands.equal + " " + returnValue
        
        delegate?.didUpdate(calcul: currentCalcul)
    }
    
    func addOperator(operand: String) {
        guard !expressionHaveResult(elements: self.elements) else {
            delegate?.didFail(error: .alreadyHaveResult)
            return
        }
        
        if canAddOperator(elements: self.elements, for: operand) {
            self.currentCalcul.append(" \(operand) ")
        } else {
            delegate?.didFail(error: .alreadyHaveOperator)
        }
    }
    
    func addNumber(number: String) {
        if expressionHaveResult(elements: self.elements) {
            delegate?.didFail(error: .alreadyHaveResult)
        } else {
            self.currentCalcul.append("\(number)")
        }
    }
    
    func resetCurrentCalcul() {
        self.currentCalcul = ""
    }
    
    //MARK: - Private
    private func expressionIsCorrect(elements: [String]) -> Bool {
        return elements.last != Operands.addition && elements.last != Operands.substraction && elements.last != Operands.division && elements.last != Operands.multiplication
    }
    
    private func expressionHaveEnoughElement(elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    private func canAddOperator(elements: [String], for operand: String) -> Bool {
        //TODO: refact ?
        if elements.first == nil && (operand == Operands.multiplication || operand == Operands.division) {
            return false
        }
        
        return elements.last != Operands.addition && elements.last != Operands.substraction && elements.last != Operands.division && elements.last != Operands.multiplication
    }
    
    private func expressionHaveResult(elements: [String]) -> Bool {
        return elements.firstIndex(of: Operands.equal) != nil
    }
    
    private func performOperation(left: Double, operatorSymbol: String, right: Double) -> Double {
        switch operatorSymbol {
        case Operands.addition: return left + right
        case Operands.substraction: return left - right
        case Operands.division:
            if left == 0 || right == 0 {
                delegate?.didFail(error: .divisionByZero)
                return 0
            } else {
                return left / right
            }
        case Operands.multiplication: return left * right
        default: delegate?.didFail(error: .invalidInput)
            return 0
        }
    }
    
    private func performOnlyMultiplicationOrDivisionOperations(for expression: inout [String]) {
        while expression.contains(Operands.multiplication) || expression.contains(Operands.division) {
            if let index = expression.firstIndex(where: { $0 == Operands.multiplication || $0 == Operands.division }) {
                guard let leftOperand = Double(expression[index - 1]),
                      let rightOperand = Double(expression[index + 1]) else {
                    delegate?.didFail(error: .unknowError)
                    return
                }
                
                let operatorSymbol = expression[index]
                let result = performOperation(left: leftOperand, operatorSymbol: operatorSymbol, right: rightOperand)
                
                expression[index - 1] = String(format: "%.2f", result)
                                
                expression.remove(at: index)
                expression.remove(at: index)
            }
        }
    }
    
    private func performOnlyAdditionOrSubstractionOperations(for expression: inout [String]) {
        while expression.count > 1 {
            guard let left = Double(expression[0]) else { return }
            let operatorSymbol = expression[1]
            guard let right = Double(expression[2]) else { return }
            
            let result = performOperation(left: left, operatorSymbol: operatorSymbol, right: right)
            
            expression[0] = String(format: "%.2f", result)
                        
            expression.remove(at: 1)
            expression.remove(at: 1)
        }
    }
    
    // Concat first element
    private func cleanExpression(elements: [String]) -> [String] {
        var data = elements
        
        //        Check first element
        if data[0] == Operands.substraction {
            
            let value = data[1]
            data.remove(at: 1)
            data[0] = Operands.substraction + value
            
        } else if data[0] == Operands.addition {
            data.remove(at: 0)
        }
        return data
    }
    
    private func formatDecimal(for value: inout String) {
        while value.last == "0" {
            value.removeLast()
        }
        
        if value.last == "." {
            value.removeLast()
        }
    }
}
