//
//  FitFinderApp.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

class PersistenceManager {
  let persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "FitFinderApp")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  init() {
    let center = NotificationCenter.default
    let notification = UIApplication.willResignActiveNotification

    center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
      guard let self = self else { return }

      if self.persistentContainer.viewContext.hasChanges {
        try? self.persistentContainer.viewContext.save()
      }
    }
  }
}

@main
struct FitFinderApp: App {
  let persistence = PersistenceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
