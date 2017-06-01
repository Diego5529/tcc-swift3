//
//  User+CoreDataProperties.swift
//  
//
//  Created by Diego Oliveira on 30/05/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var active: NSNumber?
    @NSManaged public var birth_date: NSDate?
    @NSManaged public var created_at: NSDate?
    @NSManaged public var current_sign_in_at: NSDate?
    @NSManaged public var current_sign_in_ip: String?
    @NSManaged public var email: String?
    @NSManaged public var encrypted_password: String?
    @NSManaged public var genre: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var last_name: String?
    @NSManaged public var last_sign_in_at: NSDate?
    @NSManaged public var last_sign_in_ip: String?
    @NSManaged public var long_name: String?
    @NSManaged public var name: String?
    @NSManaged public var phone_number: String?
    @NSManaged public var provider: String?
    @NSManaged public var remember_created_at: NSDate?
    @NSManaged public var reset_password_sent_at: NSDate?
    @NSManaged public var reset_password_token: String?
    @NSManaged public var sign_in_count: NSNumber?
    @NSManaged public var token: String?
    @NSManaged public var uid: String?
    @NSManaged public var updated_at: NSDate?
    @NSManaged public var user_id: Int16
    @NSManaged public var has_many_invitation: Invitation?
    @NSManaged public var has_many_users_company_type: UserCompanyType?

}
