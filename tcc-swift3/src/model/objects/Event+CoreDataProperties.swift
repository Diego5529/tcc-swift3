//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var address: String?
    @NSManaged public var address_complement: String?
    @NSManaged public var archive: NSNumber?
    @NSManaged public var city_id: NSNumber?
    @NSManaged public var company_id: NSNumber?
    @NSManaged public var confirm_password: String?
    @NSManaged public var created_at: NSDate?
    @NSManaged public var district: String?
    @NSManaged public var end_date: NSDate?
    @NSManaged public var end_hour: NSDate?
    @NSManaged public var event_category_id: NSNumber?
    @NSManaged public var event_id: Int16
    @NSManaged public var event_type_id: NSNumber?
    @NSManaged public var facebook_page: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var initial_date: NSDate?
    @NSManaged public var initial_hour: NSDate?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var long_description: String?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var max_users: NSNumber?
    @NSManaged public var min_users: NSNumber?
    @NSManaged public var note: String?
    @NSManaged public var number: String?
    @NSManaged public var password: String?
    @NSManaged public var short_description: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var updated_at: NSDate?
    @NSManaged public var url_site: String?
    @NSManaged public var use_password: NSNumber?
    @NSManaged public var zip_code: String?
    @NSManaged public var belongs_to_city: City?
    @NSManaged public var belongs_to_company: Company?
    @NSManaged public var belongs_to_event_category: EventCategory?
    @NSManaged public var belongs_to_event_type: EventType?
    @NSManaged public var has_many_invitations: Invitation?

}
