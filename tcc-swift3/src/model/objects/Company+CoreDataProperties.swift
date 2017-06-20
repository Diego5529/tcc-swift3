//
//  Company+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var company_id: Int16
    @NSManaged public var created_at: NSDate?
    @NSManaged public var updated_at: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var long_description: String?
    @NSManaged public var max_users: Int16
    @NSManaged public var min_users: Int16
    @NSManaged public var short_description: String?
    @NSManaged public var title: String?
    @NSManaged public var has_many_event: Event?
    @NSManaged public var has_many_user_company: UserCompanyType?

}
