//
//  Storage.swift
//  Tinkoff News
//
//  Created by Сергей Прокопьев on 10/01/2019.
//  Copyright © 2019 someThing. All rights reserved.
//

import Foundation
import CoreData

class Storage {
    
    // NSPersistentStore
    
    var storeUrl:URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("Storage.sqlite")
    }
    
    // NSManagedObjectModel
    
    
    let dataModelName = "Storage"
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName,
                                       withExtension: self.dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // NSPersistentStoreCoordinator
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()
    
    // masterContext
    
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    // mainContext
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    // saveContext
    
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    
    typealias SaveCompletion = () -> Void
    func performSave (with context: NSManagedObjectContext, completion: SaveCompletion? = nil ) {
        guard context.hasChanges else{ completion?()
            return
        }
        
        context.perform {
            do {
                try context.save()
                print("SAVED")
            } catch {
                print("Context save error: \(error)")
            }
            
            if let parentContext = context.parent {
                self.performSave(with: parentContext, completion: completion)
                print("???")
            } else {
                completion?()
            }
        }
        
    }
    
    // return
    
   
}

