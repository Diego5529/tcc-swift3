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
    
    var id: Int16 = 0
    var company_id: Int16 = 0
    var created_at: NSDate
    var long_description: String?
    var max_users: Int16 = 0
    var min_users: Int16 = 0
    var short_description: String?
    var title: String?
    var has_many_event: Event?
    var has_many_user_company: UserCompanyType?
    
    override init () {
        self.id = 0
        self.created_at = NSDate.init()
        self.title = ""
        self.short_description = ""
        self.long_description = ""
        
        self.min_users = 10
        self.max_users = 10
    }
    
    func getMaxCompany(context: NSManagedObjectContext) -> Int16 {
        var idMax = 0
        
        let select = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        
        do {
            let results = try context.fetch(select)
            
            idMax = results.count + 1
        }catch{
            
        }
        
        return Int16(idMax)
    }
    
    func serializer(companyObject: AnyObject) -> CompanyBean {
        let companyBean = CompanyBean()
        
        companyBean.id = companyObject.value(forKey: "id") as! Int16
        companyBean.title = companyObject.value(forKey: "title") as? String
        companyBean.short_description = companyObject.value(forKey: "short_description") as? String
        companyBean.long_description = companyObject.value(forKey: "long_description") as? String
        companyBean.min_users = companyObject.value(forKey: "min_users") as! Int16
        companyBean.max_users = companyObject.value(forKey: "max_users") as! Int16
        
        return companyBean
    }
    
    func validateCreateCompany(title: String, shortDescription: String, longDescription: String, minUsers: Int16, maxUsers: Int16, createdAt: NSDate) -> String{
        var message = ""
        
        if (title.isEmpty){
            message = "Title can not be empty."
        }
        
        return message
    }
}
