//
//  State+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }

    @NSManaged public var country_id: NSNumber?
    @NSManaged public var id: NSNumber?
    @NSManaged public var initials: String?
    @NSManaged public var name: String?
    @NSManaged public var created_at: NSDate?
    @NSManaged public var updated_at: NSDate?
    @NSManaged public var belongs_to_country: Country?
    @NSManaged public var has_many_city: City?

}
