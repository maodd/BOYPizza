//
//  OrderHistory+CoreDataProperties.swift
//  
//
//  Created by Frank Mao on 2016-12-09.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension OrderHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderHistory> {
        return NSFetchRequest<OrderHistory>(entityName: "OrderHistory");
    }

    @NSManaged public var time: NSDate?
    @NSManaged public var configuration: PizzaConfiguration?

}
