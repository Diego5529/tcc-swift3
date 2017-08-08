//
//  UserCompanyTypeBean.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 28/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import CoreData

class UserCompanyTypeBean : NSObject {
    
    var active: Bool
    var admin: Bool
    var company_id: Int16
    var created_at: NSDate
    var id: Int16 = 0
    var updated_at: NSDate
    var user_company_type_id: Int16 = 0
    var user_id: Int16
    var user_type_id: Int16
    
    override init () {
        self.active = true
        self.admin = true
        self.company_id = 0
        self.id = 0
        self.user_id = 0
        self.user_type_id = 0
        self.created_at = NSDate.init()
        self.updated_at = NSDate.init()
    }
    
    //Dao
    class func saveUserCompanyType(context: NSManagedObjectContext, userCompanyType: UserCompanyTypeBean){
        let userCompanyTypeObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "UserCompanyType", into: context)
        
        userCompanyTypeObj.setValue(userCompanyType.id, forKey: "id")
        userCompanyTypeObj.setValue(userCompanyType.user_company_type_id, forKey: "user_company_type_id")
        userCompanyTypeObj.setValue(userCompanyType.user_id, forKey: "user_id")
        userCompanyTypeObj.setValue(userCompanyType.company_id, forKey: "company_id")
        userCompanyTypeObj.setValue(userCompanyType.user_type_id, forKey: "user_type_id")
        userCompanyTypeObj.setValue(userCompanyType.admin, forKey: "admin")
        userCompanyTypeObj.setValue(userCompanyType.active, forKey: "active")
    }
    
    func getMaxUserCompanyType(context: NSManagedObjectContext) -> Int16 {
        var idMax = 0
        
        let select = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCompanyType")
        
        do {
            let results = try context.fetch(select)
            
            idMax = results.count + 1
        }catch{
            
        }
        
        return Int16(idMax)
    }
    
    class func serializer(object: AnyObject) -> UserCompanyTypeBean {
        let uct = UserCompanyTypeBean()
        
        uct.id = object.value(forKey: "id") as! Int16
        uct.user_company_type_id = object.value(forKey: "user_company_type_id") as! Int16
        uct.user_id = object.value(forKey: "user_id") as! Int16
        uct.company_id = object.value(forKey: "company_id") as! Int16
        uct.user_type_id = object.value(forKey: "user_type_id") as! Int16
        uct.admin = object.value(forKey: "admin") as! Bool
        uct.active = object.value(forKey: "active") as! Bool
        
        return uct
    }
}
