//
//  PizzaConfiguration+CoreDataProperties.swift
//  
//
//  Created by Frank Mao on 2016-12-09.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension PizzaConfiguration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PizzaConfiguration> {
        return NSFetchRequest<PizzaConfiguration>(entityName: "PizzaConfiguration");
    }

    @NSManaged public var isCustomerMade: Bool
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var toppings: String?
    @NSManaged public var countOfOrders: Int16

}
