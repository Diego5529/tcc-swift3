//
//  EventBean.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 28/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import CoreData

class EventBean : NSObject {
    
    var address: String?
    var address_complement: String?
    var archive: Bool = false
    var city_id: Int16 = 0
    var company_id: Int16 = 0
    var confirm_password: String?
    var created_at: NSDate
    var district: String?
    var end_date: NSDate
    var end_hour: NSDate
    var event_category_id: Int16 = 0
    var id: Int16 = 0
    var event_id: Int16 = 0
    var event_type_id: Int16 = 0
    var facebook_page: String?
    var initial_date: NSDate
    var initial_hour: NSDate
    var latitude: Double = 0
    var long_description: String?
    var longitude: Double = 0
    var max_users: Int16 = 0
    var min_users: Int16 = 0
    var note: String?
    var number: String?
    var password: String?
    var short_description: String?
    var status: String?
    var title: String?
    var updated_at: NSDate
    var url_site: String?
    var use_password: Bool = false
    var zip_code: String?
    var belongs_to_city: City?
    var belongs_to_company: Company?
    var belongs_to_event_category: EventCategory?
    var belongs_to_event_type: EventType?
    var has_many_invitations: Invitation?
    
    override init () {
        self.company_id = 0
        self.created_at = NSDate.init()
        self.updated_at = NSDate.init()
        
        self.initial_date = NSDate.init()
        self.end_date = NSDate.init()
        self.initial_hour = NSDate.init()
        self.end_hour = NSDate.init()
        
        self.title = ""
        self.short_description = ""
        self.long_description = ""
        
        self.city_id = 0
        
        self.min_users = 10
        self.max_users = 10
    }
    
    func getMaxEvent(context: NSManagedObjectContext) -> Int16 {
        var idMax = 0
        
        let select = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        
        do {
            let results = try context.fetch(select)
            
            idMax = results.count + 1
        }catch{
            
        }
        
        return Int16(idMax)
    }

    func serializer(object: AnyObject) -> EventBean {
        let eventBean = EventBean()
        
        eventBean.id = object.value(forKey: "id") as! Int16
        eventBean.company_id = object.value(forKey: "company_id") as! Int16
        eventBean.title = object.value(forKey: "title") as? String
        eventBean.short_description = object.value(forKey: "short_description") as? String
        eventBean.long_description = object.value(forKey: "long_description") as? String
        eventBean.min_users = object.value(forKey: "min_users") as! Int16
        eventBean.max_users = object.value(forKey: "max_users") as! Int16
        
        return eventBean
    }
    
    func validateCreateEvent(title: String, shortDescription: String, longDescription: String, minUsers: Int16, maxUsers: Int16, createdAt: NSDate) -> String{
        var message = ""
        
        if (title.isEmpty){
            message = "Title can not be empty."
        }
        
        return message
    }
}
