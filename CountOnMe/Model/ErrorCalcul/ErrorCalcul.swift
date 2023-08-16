//
//  ErrorCalcul.swift
//  CountOnMe
//
//  Created by François-Xavier on 09/08/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

import Foundation

enum ErrorCalcul: Error {
    case divisionByZero
    case invalidInput
    case alreadyHaveResult
    case alreadyHaveOperator
    case notEnoughtElement
    case unknowError
    
    var content: String {
        switch self {
        case .divisionByZero: return "Une division par zéro est impossible"
        case .invalidInput: return "Oups il y a un problème avec les données d'entrée"
        case .alreadyHaveResult: return "Veuillez relancer un nouveau calcul"
        case .alreadyHaveOperator: return "Vous ne pouvez pas ajouter cet opérateur ici"
        case .notEnoughtElement: return "Il n'y a pas assez d'éléments pour effectuer un calcul"
        case .unknowError: return "Erreur inconnue veuillez réessayer"
        }
    }
}
