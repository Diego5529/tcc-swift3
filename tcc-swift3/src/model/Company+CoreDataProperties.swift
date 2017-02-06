//
//  Company+CoreDataProperties.swift
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

extension Company {

    @NSManaged var company_id: Int16
    @NSManaged var created_at: TimeInterval
    @NSManaged var long_description: String?
    @NSManaged var max_users: Int16
    @NSManaged var min_users: Int16
    @NSManaged var short_description: String?
    @NSManaged var title: String?
    @NSManaged var has_many_event: Event?
    @NSManaged var has_many_user_company: UserCompanyType?

}
