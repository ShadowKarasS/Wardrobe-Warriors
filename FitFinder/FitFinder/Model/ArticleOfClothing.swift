//
//  ArticleOfClothing.swift
//  FitFinder
//
//  Created by Noah Frew on 2/22/21.
//

import Foundation

enum TypeOfClothing {
    case shirt
    case longSleeveShirt
    case pants
    case shorts
    case skirt
}

enum Formality {
    case formal
    case casual
}

protocol Clothing {
    var typeOfClothing: TypeOfClothing { get set }
    var appropriateTemperature: Int { get set }
    var averageColor: Colors { get set }
    var formality: Formality { get set }
}

class ArticleOfClothing: Clothing {
    var typeOfClothing: TypeOfClothing
    var appropriateTemperature: Int
    var averageColor: Colors
    var formality: Formality
    
    init(typeOfClothing: TypeOfClothing, appropriateTemperature: Int, averageColor: Colors, formality: Formality) {
        self.typeOfClothing = typeOfClothing
        self.appropriateTemperature = appropriateTemperature
        self.averageColor = averageColor
        self.formality = formality
    }
    
    
}
