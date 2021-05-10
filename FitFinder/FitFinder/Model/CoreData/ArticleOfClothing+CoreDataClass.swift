//
//  ArticleOfClothing+CoreDataClass.swift
//  FitFinder
//
//  Created by Noah Frew on 4/6/21.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(ArticleOfClothing)
public class ArticleOfClothing: NSManagedObject {
    var image: UIImage? {
        get {
            if let rawImage = rawImage {
                return UIImage(data: rawImage)
            } else {
                return nil
            }
        }
        
        set {
            if let newValue = newValue {
                rawImage = newValue.jpegData(compressionQuality: 1.0)
            }
        }
    }

    var color: Colors {
        get {
            if red > green && red > blue { // red section
                if green <= 125 && blue <= 125 {
                    return .red
                } else if green > 125 {
                    return .yellow
                } else {
                    return .magenta
                }
            } else if green > blue && green > red  { // blue section
                if blue <= 125 && green <= 125 {
                    return .green
                } else if blue > 125 {
                    return .cyan
                } else {
                    return .yellow
                }
            } else if blue > red && blue > green { // green section
                if red <= 125 && green <= 125 {
                    return .blue
                } else if red > 125 {
                    return .magenta
                } else if green > 125 {
                    return .cyan
                }
            } else { // middle section
                if red < 240 && red > 50 {
                    return .gray
                } else if red >= 240 {
                    return .white
                }
            }
            
            return .black
        }
    }

    var formality: Formality {
        if rawFormality == Formality.formal.rawValue {
            return .formal
        } else {
            return .casual
        }
    }
    
    var typeOfClothing: TypeOfClothing {
        get {
            if rawTypeOfClothing == TypeOfClothing.shirt.rawValue {
                return .shirt
            } else if rawTypeOfClothing == TypeOfClothing.longSleeveShirt.rawValue {
                return .longSleeveShirt
            } else if rawTypeOfClothing == TypeOfClothing.pants.rawValue {
                return .pants
            } else if rawTypeOfClothing == TypeOfClothing.shorts.rawValue {
                return .shorts
            } else {
                return .skirt
            }
        }
        
    }
    
    var appropriateTemperature: Temperature {
        get {
            if rawAppropriateTemperature == Temperature.veryCold.rawValue {
                return .veryCold
            } else if rawAppropriateTemperature == Temperature.cold.rawValue {
                return .cold
            } else if rawAppropriateTemperature == Temperature.mild.rawValue {
                return .mild
            } else if rawAppropriateTemperature == Temperature.hot.rawValue {
                return .hot
            } else {
                return .veryHot
            }
        }
    }
    
    var clothingCategory: String {
        if typeOfClothing == .longSleeveShirt || typeOfClothing == .shirt {
            return "top"
        } else {
            return "bottom"
        }
    }
    
    convenience init?(context: NSManagedObjectContext, image: UIImage?, red: Int16, blue: Int16, green: Int16, rawFormality: String, rawTypeOfClothing: String, rawAppropriateTemperature: String) {
        self.init(entity: ArticleOfClothing.entity(), insertInto: context)
        
        self.image = image
        self.red = red
        self.green = green
        self.blue = blue
        self.rawFormality = rawFormality
        self.rawTypeOfClothing = rawTypeOfClothing
        self.rawAppropriateTemperature = rawAppropriateTemperature
        
    }
}
