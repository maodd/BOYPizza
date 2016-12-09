//
//  ToppingConfRef+CoreDataProperties.swift
//  
//
//  Created by Frank Mao on 2016-12-09.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ToppingConfRef {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToppingConfRef> {
        return NSFetchRequest<ToppingConfRef>(entityName: "ToppingConfRef");
    }

    @NSManaged public var topping: Topping?
    @NSManaged public var pizzaConfiguration: PizzaConfiguration?

}
