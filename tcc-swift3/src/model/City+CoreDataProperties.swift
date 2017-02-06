//
//  City+CoreDataProperties.swift
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

extension City {

    @NSManaged var city_id: Int16
    @NSManaged var ddd: String?
    @NSManaged var name: String?
    @NSManaged var state_id: Int16
    @NSManaged var zip_code: String?
    @NSManaged var belongs_to_state: State?
    @NSManaged var has_many_event: Event?

}
