//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: - Property
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!
    
    private var calculator: Calculator!
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculator = Calculator(textView: textView)
    }
        
    
    //MARK: - Action
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        textView.text.append(numberText)
    }
    
    @IBAction private func tappedAdditionButton(_ sender: UIButton) {
        if calculator.canAddOperator {
            textView.text.append(" + ")
        } else {
            makeAlert(message: "Un Opérateur est déja mis !")
        }
    }
    
    @IBAction private func tappedSubstractionButton(_ sender: UIButton) {
        if calculator.canAddOperator {
            textView.text.append(" - ")
        } else {
            makeAlert(message: "Un Opérateur est déja mis !")
        }
    }
    
    @IBAction private func tappedMultiplicatorButton(_ sender: UIButton) {
        if calculator.canAddOperator {
            textView.text.append(" x ")
        } else {
            makeAlert(message: "Un Opérateur est déja mis !")
        }
    }
    
    @IBAction private func tappedDivisionButton(_ sender: UIButton) {
        if calculator.canAddOperator {
            textView.text.append(" / ")
        } else {
            makeAlert(message: "Un Opérateur est déja mis !")
        }
    }
    
    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        
        guard calculator.expressionHaveResult else {
            return makeAlert(message: "Démarrez un nouveau calcul !")
        }
        
        guard calculator.expressionIsCorrect else {
            return makeAlert(message: "Entrez une expression correcte !")
        }
        
        guard calculator.expressionHaveEnoughElement else {
            return makeAlert(message: "Démarrez un nouveau calcul !")
        }
        
        calculator.makeCalcul()
        
    }
    
    //MARK: - Private
    private func makeAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
