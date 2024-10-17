//
//  DBManager.swift
//  SmartMovie
//
//  Created by Nguyễn Đình Kiên on 04/04/2023.
//

import Foundation
import UIKit
import CoreData

class DBManager {
    static let shared: DBManager = DBManager()
    var managerContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmartMovie")
        container.loadPersistentStores(completionHandler: { (_ storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        if managerContext.hasChanges {
            do {
                try managerContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Core Data Saving support
    func addStar(idMovie: Int) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managerContext) else {
            return
        }
        guard let object = NSManagedObject(entity: entity, insertInto: managerContext) as? Favorite else {
            return
        }
        object.idMovie = Int32(Int(idMovie))
        saveContext()
    }

    func getfavorite(idMovie: Int) -> Bool? {
        let fetcheRequest: NSFetchRequest<Favorite> =  Favorite.fetchRequest()
        fetcheRequest.predicate = NSPredicate(format: "idMovie == %d", idMovie)
        do {
            if let result = try managerContext.fetch(fetcheRequest).first {
                return result.isStar
            }
        } catch {
            return nil
        }
        return nil
    }

    func deleteFavorite(idMovie: Int) {
        let fetcheRequest: NSFetchRequest<Favorite> =  Favorite.fetchRequest()
        fetcheRequest.predicate = NSPredicate(format: "idMovie == %d", idMovie)
        do {
            if let result = try managerContext.fetch(fetcheRequest).first {
                managerContext.delete(result)
                saveContext()
            }
        } catch {
            print("Error delete favorites: \(error.localizedDescription)")

        }
    }
}
