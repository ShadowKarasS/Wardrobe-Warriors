//
//  ArticleOfClothing+CoreDataProperties.swift
//  FitFinder
//
//  Created by Noah Frew on 4/6/21.
//
//

import Foundation
import CoreData


extension ArticleOfClothing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleOfClothing> {
        return NSFetchRequest<ArticleOfClothing>(entityName: "ArticleOfClothing")
    }

    @NSManaged public var rawAppropriateTemperature: String?
    @NSManaged public var blue: Int16
    @NSManaged public var green: Int16
    @NSManaged public var picked: Int16
    @NSManaged public var rawFormality: String?
    @NSManaged public var rawImage: Data?
    @NSManaged public var rawTypeOfClothing: String?
    @NSManaged public var red: Int16

}

extension ArticleOfClothing : Identifiable {

}
