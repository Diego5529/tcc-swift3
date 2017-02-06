//
//  Guest+CoreDataProperties.swift
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

extension Guest {

    @NSManaged var created_at: TimeInterval
    @NSManaged var event_id: Int16
    @NSManaged var guest_user_id: Int16
    @NSManaged var host_user_id: Int16
    @NSManaged var invitation_id: Int16
    @NSManaged var invitation_type_id: Int16
    @NSManaged var updated_at: TimeInterval
    @NSManaged var belongs_to_event: Event?
    @NSManaged var belongs_to_invitation_type: GuestType?
    @NSManaged var belongs_to_user: User?

}
