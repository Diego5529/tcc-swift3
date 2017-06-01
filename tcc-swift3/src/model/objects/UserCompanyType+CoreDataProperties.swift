//
//  UserCompanyType+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension UserCompanyType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCompanyType> {
        return NSFetchRequest<UserCompanyType>(entityName: "UserCompanyType")
    }

    @NSManaged public var active: NSNumber?
    @NSManaged public var admin: NSNumber?
    @NSManaged public var company_id: NSNumber?
    @NSManaged public var id: NSNumber?
    @NSManaged public var user_company_type_id: Int16
    @NSManaged public var user_id: NSNumber?
    @NSManaged public var user_type_id: NSNumber?
    @NSManaged public var belongs_user_type: UserType?
    @NSManaged public var has_many_company: Company?
    @NSManaged public var has_many_user: User?

}
