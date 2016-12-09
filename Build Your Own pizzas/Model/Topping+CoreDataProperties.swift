//
//  Topping+CoreDataProperties.swift
//  
//
//  Created by Frank Mao on 2016-12-09.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Topping {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topping> {
        return NSFetchRequest<Topping>(entityName: "Topping");
    }

    @NSManaged public var name: String?

}
