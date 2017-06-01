//
//  City+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var ddd: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var state_id: NSNumber?
    @NSManaged public var zip_code: String?
    @NSManaged public var belongs_to_state: State?
    @NSManaged public var has_many_event: Event?

}
