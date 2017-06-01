//
//  InvitationBean.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 30/05/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import CoreData

class InvitationBean : NSObject {
    
    public var email: String?
    public var created_at: NSDate
    public var event_id: Int16 = 0
    public var guest_user_id: Int16 = 0
    public var host_user_id: Int16 = 0
    public var id: Int16 = 0
    public var invitation_id: Int16 = 0
    public var invitation_type_id: Int16 = 0
    public var updated_at: NSDate?
    public var belongs_to_event: Event?
    public var belongs_to_invitation_type: InvitationType?
    public var belongs_to_user: User?
    
    override init () {
        self.id = 0
        self.created_at = NSDate.init()
        self.email = ""
    }
    
    class func getMaxInvitation(context: NSManagedObjectContext) -> Int16 {
        var idMax = 0
        
        let select = NSFetchRequest<NSFetchRequestResult>(entityName: "Invitation")
        
        do {
            let results = try context.fetch(select)
            
            idMax = results.count + 1
        }catch{
            
        }
        
        return Int16(idMax)
    }
    
    func serializer(object: AnyObject) -> InvitationBean {
        let invitationBean = InvitationBean()
        
        invitationBean.invitation_id = object.value(forKey: "invitation_id") as! Int16
        
        return invitationBean
    }
    
    func validateCreateInvitation(title: String, shortDescription: String, longDescription: String, minUsers: Int16, maxUsers: Int16, createdAt: NSDate) -> String{
        var message = ""
        
        if (title.isEmpty){
            message = "Title can not be empty."
        }
        
        return message
    }
}
