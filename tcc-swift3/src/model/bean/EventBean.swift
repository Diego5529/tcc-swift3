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
    
    func validateCreateEvent(title: String, shortDescription: String, longDescription: String, minUsers: Int16, maxUsers: Int16, createdAt: NSDate) -> String{
        var message = ""
        
        if (title.isEmpty){
            message = "Title can not be empty."
        }
        
        return message
    }
}
