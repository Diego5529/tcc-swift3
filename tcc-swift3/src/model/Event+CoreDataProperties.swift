//
//  Event+CoreDataProperties.swift
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

extension Event {

    @NSManaged var address: String?
    @NSManaged var address_complement: String?
    @NSManaged var archive: Bool
    @NSManaged var city_id: Int16
    @NSManaged var company_id: Int16
    @NSManaged var confirm_password: String?
    @NSManaged var created_at: TimeInterval
    @NSManaged var district: String?
    @NSManaged var end_date: TimeInterval
    @NSManaged var end_hour: TimeInterval
    @NSManaged var event_category_id: Int16
    @NSManaged var event_id: Int16
    @NSManaged var event_type_id: Int16
    @NSManaged var facebook_page: String?
    @NSManaged var initial_date: TimeInterval
    @NSManaged var initial_hour: TimeInterval
    @NSManaged var latitude: Double
    @NSManaged var long_description: String?
    @NSManaged var longitude: Double
    @NSManaged var max_users: Int16
    @NSManaged var min_users: Int16
    @NSManaged var note: String?
    @NSManaged var number: String?
    @NSManaged var password: String?
    @NSManaged var short_description: String?
    @NSManaged var status: String?
    @NSManaged var title: String?
    @NSManaged var updated_at: TimeInterval
    @NSManaged var url_site: String?
    @NSManaged var use_password: Bool
    @NSManaged var zip_code: String?
    @NSManaged var belongs_to_city: City?
    @NSManaged var belongs_to_company: Company?
    @NSManaged var belongs_to_event_category: EventCategory?
    @NSManaged var belongs_to_event_type: EventType?
    @NSManaged var has_many_invitations: Guest?

}
