//
//  ArticleOfClothing+CoreDataClass.swift
//  FitFinder
//
//  Created by Noah Frew on 3/2/21.
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
        
        set {
            
        }
    }

    var formality: Formality {
        if rawFormality == true {
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
        
        set {
            
        }
        
    }
    
    convenience init?(context: NSManagedObjectContext, image: UIImage?, color: Colors, rawFormality: Bool, typeOfClothing: TypeOfClothing, appropriateTemperature: Double) {
        self.init(entity: ArticleOfClothing.entity(), insertInto: context)
        
        self.image = image
        self.color = color
        self.rawFormality = rawFormality
        self.typeOfClothing = typeOfClothing
        self.appropriateTemperature = appropriateTemperature
        
    }
}
