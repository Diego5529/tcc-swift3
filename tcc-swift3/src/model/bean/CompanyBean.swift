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
    var updated_at: NSDate
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
        self.updated_at = self.created_at
        self.title = ""
        self.short_description = ""
        self.long_description = ""
        
        self.min_users = 10
        self.max_users = 10
    }
    
    //Dao
    class func saveCompany(context: NSManagedObjectContext, company: CompanyBean){
        let companyObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        companyObj.setValue(company.id, forKey: "id")
        companyObj.setValue(company.company_id, forKey: "company_id")
        companyObj.setValue(company.title, forKey: "title")
        companyObj.setValue(company.short_description, forKey: "short_description")
        companyObj.setValue(company.long_description, forKey: "long_description")
        companyObj.setValue(company.min_users, forKey: "min_users")
        companyObj.setValue(company.max_users, forKey: "max_users")
        companyObj.setValue(company.created_at, forKey: "created_at")
        companyObj.setValue(company.updated_at, forKey: "updated_at")
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
    
    class func getCompanyById(context: NSManagedObjectContext, id: Int16) -> NSManagedObject {
        
        let obj = NSManagedObject()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Company")
        
        fetchRequest.predicate = NSPredicate(format: "company_id == %i", id)
        
        do {
            let obj = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            return obj as! NSManagedObject

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return obj 
    }
    //
    
    func serializer(companyObject: AnyObject) -> CompanyBean {
        let companyBean = CompanyBean()
        
        companyBean.id = companyObject.value(forKey: "id") as! Int16
        companyBean.company_id = companyObject.value(forKey: "company_id") as! Int16
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
