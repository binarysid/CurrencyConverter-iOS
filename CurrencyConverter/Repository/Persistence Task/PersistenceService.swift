//
//  PersistanceService.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 13/10/22.
//

import Foundation
import CoreData

class PersistenceService{
    private init(){}
    // MARK: - Core Data stack
    static var context:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyConverter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
            else{
                let description = NSPersistentStoreDescription()
                description.shouldInferMappingModelAutomatically = true
                container.persistentStoreDescriptions = [description]
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


