//
//  CoreDataHandler.swift
//  ToolTracking
//
//  Created by User on 12/25/20.
//

import Foundation
import CoreData

class CoreDataHandler {
    public static let sharedInstance = CoreDataHandler()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToolTracking")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

            }
        }
    }
    
    // MARK: - Entity description for given name.
   public func entityForName(entityName:String)-> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: persistentContainer.viewContext)!
    }
    
    // MARK: - Create a new entity for given name.
   public func newEntityForName(entityName:String)-> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: persistentContainer.viewContext)
    }
    
    // MARK: - Get all Datas
    public func getAllDatas(entity:String)-> [Any] {
        var data:[Any] = []
        let fetchRequest : NSFetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: entity)
        do {
            data =   try persistentContainer.viewContext.fetch(fetchRequest)
        }catch {
            print(error)
        }
        return data
    }
    
    public func getAllDatasWithPredicate(entity:String,predicate:NSPredicate?, sortDescriptor: NSSortDescriptor?)-> [Any] {
        var data:[Any] = []
        do {
            let fetchRequest : NSFetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: entity)
            if(predicate != nil) {
                fetchRequest.predicate = predicate
            }
            if(sortDescriptor != nil) {
                fetchRequest.sortDescriptors = [sortDescriptor!]
            }
            data = try persistentContainer.viewContext.fetch(fetchRequest) as [Any]
        } catch let error as NSError {
            print(error)
        }
        return data
    }
    
    // MARK:- Delete managed object.
    public func deleteObject(object:NSManagedObject) ->Void {
        persistentContainer.viewContext.delete(object)
    }
    
    public func deleteAllDataWithCondition(name: String,predicate:NSPredicate?) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.predicate = predicate
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try (persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext))
        } catch _ as NSError {
            //print(error)
        }
    }
}
