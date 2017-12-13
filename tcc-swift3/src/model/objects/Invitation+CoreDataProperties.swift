//
//  Invitation+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension Invitation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invitation> {
        return NSFetchRequest<Invitation>(entityName: "Invitation")
    }

    @NSManaged public var created_at: NSDate?
    @NSManaged public var event_id: NSNumber?
    @NSManaged public var user_id: NSNumber?
    @NSManaged public var host_user_id: NSNumber?
    @NSManaged public var id: NSNumber?
    @NSManaged public var email: String?
    @NSManaged public var invitation_id: Int16
    @NSManaged public var invitation_type_id: NSNumber?
    @NSManaged public var updated_at: NSDate?
    @NSManaged public var belongs_to_event: Event?
    @NSManaged public var belongs_to_invitation_type: InvitationType?
    @NSManaged public var belongs_to_user: User?
}
