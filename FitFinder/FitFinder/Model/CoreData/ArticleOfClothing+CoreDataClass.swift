//
//  ArticleOfClothing+CoreDataClass.swift
//  FitFinder
//
//  Created by Noah Frew on 2/23/21.
//
//

import Foundation
import CoreData

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
        let color = UIColor(red: rawRed, green: rawGreen, blue: rawBlue, alpha: rawAlpha)
        let hexString = color.toHexString()
        // red
        if rawRed > 138 && rawGreen < 160 && rawBlue < 128 {
            return .red
            
        // orange
        } else if rawRed == 255 && rawGreen > 68 && rawGreen < 215 && rawBlue < 80 {
            return .orange
            
            // yellow
        } else if rawRed > 188 && rawGreen > 182 && blue < 225 {
            return .yellow
        }
        // green
        // indigo
        // white
        // black
        // tan
    }
}

    // things to test
    // ::::: Try Percentage
    // ::::: 



convenience init(image: UImage?) {
    
    self.image = image
}
}
