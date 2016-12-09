    //
//  Repository.swift
//  Build Your Own pizzas
//
//  Created by Frank Mao on 2016-12-09.
//  Copyright © 2016 mazoic. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Repository {
    
    
    static let sharedInstance = Repository()
    
    func saveNewToppingIfNotExists(name: String) {
        
        if getAllToppings().filter({ (topping) -> Bool in
            
            return topping.name?.uppercased() == name.uppercased()
            
        }).count > 0 {
            print("\(name) topping exists, skipping save.")
            return
        }
    
        let entity = NSEntityDescription.entity(forEntityName: "Topping", in: getContext())
        let newTopping = NSManagedObject(entity: entity!, insertInto: getContext()) as! Topping
        newTopping.name = name
        
        //save the object
        saveContext()
    }
    
    func getAllToppings () -> [Topping] {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Topping> = Topping.fetchRequest()
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
            for topping in searchResults as [Topping]  {
                //get the Key Value pairs (although there may be a better way to do that...
                print("\(topping.name ?? "no name")")
            }
            
            return searchResults
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return []
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Build_Your_Own_pizzas")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getContext () -> NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = getContext()
        if context.hasChanges {
            do {
                try context.save()
                print("saved!")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // sample data
    
    func parseSampleData() -> [String] {
        let jsonFilePath:NSString = Bundle.main.path(forResource: "sampleData", ofType: "json")! as NSString
        guard let jsonData = NSData.dataWithContentsOfMappedFile(jsonFilePath as String) as? NSData else {fatalError("invalid sample data")}
        
        let json = JSON(data: jsonData as Data) // Note: data: parameter name
        
        let toppings = NSMutableSet()
        
        for item in json.arrayValue {
            for topping in item["toppings"].arrayValue {
                
                toppings.add(topping.stringValue)

            }
        }
        
        print(toppings)
        
        return toppings.allObjects as! [String]
    }
    
    func initializeDb() {
        for topping in parseSampleData() {
            saveNewToppingIfNotExists(name: topping)
        }
    }
}
