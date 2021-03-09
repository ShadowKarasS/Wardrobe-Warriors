//
//  ArticleOfClothing+CoreDataProperties.swift
//  FitFinder
//
//  Created by Noah Frew on 3/2/21.
//
//

import Foundation
import CoreData


extension ArticleOfClothing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleOfClothing> {
        return NSFetchRequest<ArticleOfClothing>(entityName: "ArticleOfClothing")
    }

    @NSManaged public var appropriateTemperature: Double
    @NSManaged public var rawFormality: Bool
    @NSManaged public var blue: Int16
    @NSManaged public var green: Int16
    @NSManaged public var rawImage: Data?
    @NSManaged public var red: Int16
    @NSManaged public var rawTypeOfClothing: String?

}

extension ArticleOfClothing : Identifiable {

}
