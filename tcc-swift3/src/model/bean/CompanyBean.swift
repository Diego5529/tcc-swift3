//
//  CompanyBean.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 27/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import CoreData

class CompanyBean : NSObject {
    
    var company_id: Int16 = 0
    var created_at: NSDate
    var id: Int16 = 0
    var long_description: String?
    var max_users: Int16 = 0
    var min_users: Int16 = 0
    var short_description: String?
    var title: String?
    var updated_at: NSDate
    
    override init () {
        self.id = 0
        self.created_at = NSDate.init()
        self.updated_at = self.created_at
        self.title = ""
        self.short_description = ""
        self.long_description = ""
        
        self.min_users = 10
        self.max_users = 10
    }
    
    func validateCreateCompany(title: String, shortDescription: String, longDescription: String, minUsers: Int16, maxUsers: Int16, createdAt: NSDate) -> String{
        var message = ""
        
        if (title.isEmpty){
            message = "Title can not be empty."
        }
        
        return message
    }
}
