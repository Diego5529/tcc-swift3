//
//  Country+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var initials: String?
    @NSManaged public var name: String?
    @NSManaged public var has_many_state: State?

}
