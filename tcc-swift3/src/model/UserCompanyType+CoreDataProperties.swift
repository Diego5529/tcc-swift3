//
//  UserCompanyType+CoreDataProperties.swift
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

extension UserCompanyType {

    @NSManaged var active: Bool
    @NSManaged var admin: Bool
    @NSManaged var company_id: Int16
    @NSManaged var user_company_type_id: Int16
    @NSManaged var user_id: Int16
    @NSManaged var user_type_id: Int16
    @NSManaged var belongs_user_type: UserType?
    @NSManaged var has_many_company: Company?
    @NSManaged var has_many_user: User?

}
