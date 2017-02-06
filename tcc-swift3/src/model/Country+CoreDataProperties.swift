//
//  Country+CoreDataProperties.swift
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

extension Country {

    @NSManaged var country_id: Int16
    @NSManaged var initials: String?
    @NSManaged var name: String?
    @NSManaged var has_many_state: State?

}
