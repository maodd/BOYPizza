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
    
    
    func saveNewTopping(name: String, _ dupCheck: Bool = true) {
        if dupCheck {
            if getAllToppings().filter({ (topping) -> Bool in
                
                return topping.name?.uppercased() == name.uppercased()
                
            }).count > 0 {
                print("\(name) topping exists, skipping save.")
                return
            }
        }
    
        let entity = NSEntityDescription.entity(forEntityName: "Topping", in: getContext())
        let newTopping = NSManagedObject(entity: entity!, insertInto: getContext()) as! Topping
        newTopping.name = name
        
 
    }
    
    func getAllToppings () -> [Topping] {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Topping> = Topping.fetchRequest()
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of Toppings = \(searchResults.count)")
            
            //You need to convert to NSManagedObject to use 'for' loops
//            for topping in searchResults as [Topping]  {
//                //get the Key Value pairs (although there may be a better way to do that...
//                print("\(topping.name ?? "no name")")
//            }
            
            return searchResults
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return []
    }
    // MARK: Configuration
    enum ConfigurationSortType {
        case countOfOrders
        case toppings
    }
    
    func getAllConfigurations (sortBy: ConfigurationSortType = .countOfOrders, top: Int = 20) -> [PizzaConfiguration] {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<PizzaConfiguration> = PizzaConfiguration.fetchRequest()
        
        switch sortBy {
        case .countOfOrders:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "countOfOrders", ascending: false)]
        case .toppings:
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "toppings", ascending: true)]
        
        }
        
        
        fetchRequest.fetchLimit = top
        
        do {
            //go get the results
            let searchResults = try getContext().fetch(fetchRequest)
            
            
            //I like to check the size of the returned results!
            print ("num of PizzaConfiguration = \(searchResults.count)")
            
            
            
            //You need to convert to NSManagedObject to use 'for' loops
            for configuration in searchResults as [PizzaConfiguration]  {
                //get the Key Value pairs (although there may be a better way to do that...
                print("\(configuration.toppings ?? "no name")")
            }
            
            return searchResults
            
        } catch {
            print("Error with request: \(error)")
        }
        
        return []
    }
    
    func makeConfigurationNameFrom(toppings: [String]) -> String {
        return toppings.sorted{$0.lowercased() < $1.lowercased()}.joined(separator: ",").lowercased()
    }
    
    func saveNewConfiguration(toppings: String, countOfOrders: Int = 0,  _ dupCheck: Bool = true) {
        
        let refinedToppings = makeConfigurationNameFrom(toppings: toppings.components(separatedBy: ",")).lowercased()
        
        if dupCheck {
            if getAllConfigurations().filter({ (cfg) -> Bool in
                
                return cfg.toppings?.lowercased() == refinedToppings
                
            }).count > 0 {
                print("\(toppings) configuration exists, skipping save.")
                return
            }
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "PizzaConfiguration", in: getContext())
        let newConfiguration = NSManagedObject(entity: entity!, insertInto: getContext()) as! PizzaConfiguration
      
        newConfiguration.toppings = toppings
        newConfiguration.countOfOrders = Int16(countOfOrders)
        
 
    }
    
    // MARK: Order
//    func saveNewOrder(toppings: [String]) {
//        
//        if getAllToppings().filter({ (topping) -> Bool in
//            
//            return topping.name?.uppercased() == name.uppercased()
//            
//        }).count > 0 {
//            print("\(name) topping exists, skipping save.")
//            return
//        }
//        
//        let entity = NSEntityDescription.entity(forEntityName: "Topping", in: getContext())
//        let newTopping = NSManagedObject(entity: entity!, insertInto: getContext()) as! Topping
//        newTopping.name = name
//        
//        //save the object
//        saveContext()
//    }
    
    
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
    
    func parseSampleData() -> [[String]] {
        let jsonFilePath:NSString = Bundle.main.path(forResource: "sampleData", ofType: "json")! as NSString
        guard let jsonData = NSData.dataWithContentsOfMappedFile(jsonFilePath as String) as? NSData else {fatalError("invalid sample data")}
        
        let json = JSON(data: jsonData as Data) // Note: data: parameter name

        
        var orders = [[String]]()
        
        for item in json.arrayValue {
            var order = [String]()
            for topping in item["toppings"].arrayValue {
                
                order.append(topping.stringValue)

            }
            
            orders.append(order)
        }
        
        return orders
//
//        print(toppings)
//        
//        return  toppings.allObjects as! [String]
    }
    
    func initializeDb() {
        if getAllToppings().count > 0 {
            print("db already initialized.")
            return
        }
        
        let toppings = NSMutableSet()
        let configurations = NSMutableSet()
        var configuratoinOrderCounts = [String:Int]()
        
        for order in parseSampleData()  {
            
            for topping in order {
                
                toppings.add(topping)
                
            }
            
            let cfgName = makeConfigurationNameFrom(toppings: order)
            if configurations.contains(cfgName) {
                guard let originalCount = configuratoinOrderCounts[cfgName]  else {fatalError()}
                
                configuratoinOrderCounts[cfgName] = originalCount + 1

            }else{
                configurations.add(cfgName)
                configuratoinOrderCounts[cfgName]  = 1
            }
            
           
        }
        
        for (cfgNameKey, value) in configuratoinOrderCounts {
            saveNewConfiguration(toppings: cfgNameKey, countOfOrders: value, false)
        }
        
        for topping in toppings {
            saveNewTopping(name: topping as! String, false)
        }
    }
}
