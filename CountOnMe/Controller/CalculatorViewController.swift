//
//  CalculatorViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class CalculatorViewController: UIViewController, CalculatorModelDelegate {
    
    //MARK: - Property
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var numberButtons: [UIButton]!
    
    private var model = CalculatorModel()
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
    }
    
    //MARK: - CalculatorModelDelegate
    func didFail(error: ErrorCalcul) {
        displayAlert(message: error.content)
    }
    
    func didUpdate(calcul: String) {
        self.textView.text = calcul
    }
    
    //MARK: - Action
    @IBAction private func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        model.addNumber(numberText)
    }
    
    @IBAction private func tappedAdditionButton(_ sender: UIButton) {
        model.addOperator(Operator.addition)
    }
    
    @IBAction private func tappedSubstractionButton(_ sender: UIButton) {
        model.addOperator(Operator.subtraction)
    }
    
    @IBAction private func tappedMultiplicatorButton(_ sender: UIButton) {
        model.addOperator(Operator.multiplication)
    }
    
    @IBAction private func tappedDivisionButton(_ sender: UIButton) {
        model.addOperator(Operator.division)
    }
    
    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        model.calcul()
    }
    
    @IBAction private func clear() {
        model.clear()
    }
    
    //MARK: - Private
    private func displayAlert(message: String) {
        let alertVC = UIAlertController(title: "Erreur !", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
