//
//  CalculatorModel.swift
//  CountOnMe
//
//  Created by François-Xavier on 16/08/2023.
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
        
        var operationsToReduce = concatFirstElementWithOperand(elements: self.elements)
        
        //Calcul first multiplication and division
        performOnlyMultiplicationOrDivisionOperations(for: &operationsToReduce)
        // Calcul soustraction and addition
        performOnlyAdditionOrSubtractionOperations(for: &operationsToReduce)
        
        var returnValue = operationsToReduce[0]
        
        formatDecimal(for: &returnValue)
        
        currentCalcul += " " + Operator.equal + " " + returnValue
    }
    
    func addOperator(_ selectedOperator: String) {
        guard !expressionHaveResult(elements: self.elements) else {
            delegate?.didFail(error: .alreadyHaveResult)
            return
        }
        
        if canAddOperator(elements: self.elements, for: selectedOperator) {
            self.currentCalcul.append(" \(selectedOperator) ")
        } else {
            delegate?.didFail(error: .operatorError)
        }
    }
    
    func addNumber(_ number: String) {
        if expressionHaveResult(elements: self.elements) {
            delegate?.didFail(error: .alreadyHaveResult)
        } else {
            self.currentCalcul.append("\(number)")
        }
    }
    
    func clear() {
        self.currentCalcul = ""
    }
    
    //MARK: - Private
    private func expressionIsCorrect(elements: [String]) -> Bool {
        return elements.last != Operator.addition && elements.last != Operator.subtraction && elements.last != Operator.division && elements.last != Operator.multiplication
    }
    
    private func expressionHaveEnoughElement(elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    private func canAddOperator(elements: [String], for selectedOperator: String) -> Bool {
        if elements.first == nil && (selectedOperator == Operator.multiplication || selectedOperator == Operator.division || selectedOperator == Operator.equal) {
            return false
        }
        
        return elements.last != Operator.addition && elements.last != Operator.subtraction && elements.last != Operator.division && elements.last != Operator.multiplication
    }
    
    private func expressionHaveResult(elements: [String]) -> Bool {
        return elements.firstIndex(of: Operator.equal) != nil
    }
    
    private func performOperation(left: Double, operatorSymbol: String, right: Double) -> Double {
        switch operatorSymbol {
        case Operator.addition: return left + right
        case Operator.subtraction: return left - right
        case Operator.division:
            if left == 0 || right == 0 {
                delegate?.didFail(error: .divisionByZero)
                return 0
            } else {
                return left / right
            }
        case Operator.multiplication: return left * right
        default: delegate?.didFail(error: .invalidInput)
            return 0
        }
    }
    
    private func performOnlyMultiplicationOrDivisionOperations(for expression: inout [String]) {
        while expression.contains(Operator.multiplication) || expression.contains(Operator.division) {
            if let index = expression.firstIndex(where: { $0 == Operator.multiplication || $0 == Operator.division }) {
                guard let leftOperand = Double(expression[index - 1]),
                      let rightOperand = Double(expression[index + 1]) else {
                    delegate?.didFail(error: .invalidInput)
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
    
    private func performOnlyAdditionOrSubtractionOperations(for expression: inout [String]) {
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
    
    private func concatFirstElementWithOperand(elements: [String]) -> [String] {
        var data = elements
        
        if data[0] == Operator.subtraction {
            
            let value = data[1]
            data.remove(at: 1)
            data[0] = Operator.subtraction + value
            
        } else if data[0] == Operator.addition {
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
