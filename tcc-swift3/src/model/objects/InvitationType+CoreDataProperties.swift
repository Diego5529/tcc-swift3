//
//  InvitationType+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension InvitationType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InvitationType> {
        return NSFetchRequest<InvitationType>(entityName: "InvitationType")
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var long_description: String?
    @NSManaged public var short_description: String?
    @NSManaged public var title: String?
    @NSManaged public var created_at: NSDate?
    @NSManaged public var updated_at: NSDate?
    @NSManaged public var has_many_invitations: Invitation?

}
