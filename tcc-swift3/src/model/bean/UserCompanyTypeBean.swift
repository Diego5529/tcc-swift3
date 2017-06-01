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
    
    var id: Int16 = 0
    var user_company_type_id: Int16 = 0
    var active: Bool
    var admin: Bool
    var company_id: Int16
    var user_id: Int16
    var user_type_id: Int16
    
    override init () {
        
        self.active = true
        self.admin = true
        self.company_id = 0
        self.id = 0
        self.user_id = 0
        self.user_type_id = 0
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
}
