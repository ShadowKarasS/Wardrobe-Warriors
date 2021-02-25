//
//  ArticleOfClothing+CoreDataProperties.swift
//  FitFinder
//
//  Created by Noah Frew on 2/23/21.
//
//

import Foundation
import CoreData


extension ArticleOfClothing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleOfClothing> {
        return NSFetchRequest<ArticleOfClothing>(entityName: "ArticleOfClothing")
    }

    @NSManaged public var typeOfClothing: String?
    @NSManaged public var formality: Bool
    @NSManaged public var appropriateTemperature: Double
    @NSManaged public var rawImage: Data?
    @NSManaged public var rawRed: Double
    @NSManaged public var rawGreen: Double
    @NSManaged public var rawBlue: Double
    @NSManaged public var rawAlpha: Double

}

extension ArticleOfClothing : Identifiable {

}
