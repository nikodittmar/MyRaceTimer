//
//  PersistenceController.swift
//  MyRaceTimer
//
//  Created by niko dittmar on 4/18/23.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = ProcessInfo.processInfo.arguments.contains("forTesting") ? PersistenceController(inMemory: true) : PersistenceController()
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MyRaceTimer")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
