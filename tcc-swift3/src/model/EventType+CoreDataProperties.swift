//
//  EventType+CoreDataProperties.swift
//  
//
//  Created by Diego on 8/7/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EventType {

    @NSManaged var event_type_id: Int16
    @NSManaged var long_description: String?
    @NSManaged var short_description: String?
    @NSManaged var title: String?
    @NSManaged var has_many_events: Event?

}
