//
//  EventType+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension EventType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventType> {
        return NSFetchRequest<EventType>(entityName: "EventType")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var long_description: String?
    @NSManaged public var short_description: String?
    @NSManaged public var title: String?
    @NSManaged public var has_many_events: Event?

}
