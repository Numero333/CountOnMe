//
//  CalculatorViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController, CalculatorDelegate {
    
    //MARK: - Property
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!
    
    private var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    
    private var calculator = Calculator()
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        calculator.delegate = self
    }
    
    
    //MARK: - Action
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.addNumber(for: elements, number: numberText)
    }
    
    @IBAction private func tappedAdditionButton(_ sender: UIButton) {
        calculator.addOperator(for: elements, operand: "+")
    }
    
    @IBAction private func tappedSubstractionButton(_ sender: UIButton) {
        calculator.addOperator(for: elements, operand: "-")
    }
    
    @IBAction private func tappedMultiplicatorButton(_ sender: UIButton) {
        calculator.addOperator(for: elements, operand: "x")
    }
    
    @IBAction private func tappedDivisionButton(_ sender: UIButton) {
        calculator.addOperator(for: elements, operand: "/")
    }
    
    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        calculator.calcul(for: elements)
    }
    
    @IBAction func reset() {
        self.textView.text = ""
    }
    
    //MARK: - Private
    private func displayAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur !", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - CalculatorDelegate
    func didPerformCalculation(result: String) {
        self.textView.text = self.textView.text + result
    }
    
    func didFail(error: ErrorCalcul) {
        switch error {
        case .divisionByZero:
            displayAlert(message: "Une division par zéro est impossible")
        case .alreadyHaveResult:
            displayAlert(message: "Il y a déjà un résultat commencer une nouvelle opération")
        case .notEnoughtElement:
            displayAlert(message: "Il n'y a pas assez d'éléments pour effectuer un calcul")
        case .unknowError:
            displayAlert(message: "Erreur inconnue veuillez réessayer")
        case .alreadyHaveOperator:
            displayAlert(message: "Vous ne pouvez pas ajouter cet opérateur ici")
        case .invalidInput:
            displayAlert(message: "Oups il y a un problème avec les données d'entrée")
        }
    }
    
    func addOperator(operand: String) {
        textView.text.append(" \(operand) ")
    }
    
    func addNumber(number: String) {
        textView.text.append("\(number)")
    }
}
