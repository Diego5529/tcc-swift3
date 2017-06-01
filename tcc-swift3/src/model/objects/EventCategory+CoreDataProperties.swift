//
//  EventCategory+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension EventCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventCategory> {
        return NSFetchRequest<EventCategory>(entityName: "EventCategory")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var long_description: String?
    @NSManaged public var short_description: String?
    @NSManaged public var title: String?
    @NSManaged public var has_many_events: Event?

}
