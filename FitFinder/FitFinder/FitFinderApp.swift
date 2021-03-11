//
//  FitFinderApp.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

@main
struct FitFinderApp: App {
  let persistence = PersistenceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.persistentContainer.viewContext)
        }
    }
}
