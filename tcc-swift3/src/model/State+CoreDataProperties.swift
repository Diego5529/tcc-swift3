//
//  State+CoreDataProperties.swift
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

extension State {

    @NSManaged var country_id: Int16
    @NSManaged var initials: String?
    @NSManaged var name: String?
    @NSManaged var state_id: Int16
    @NSManaged var belongs_to_country: Country?
    @NSManaged var has_many_city: City?

}
