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
    
    public var email: String
    public var created_at: NSDate
    public var event_id: Int16 = 0
    public var guest_user_id: Int16 = 0
    public var host_user_id: Int16 = 0
    public var id: Int16 = 0
    public var invitation_id: Int16 = 0
    public var invitation_type_id: Int16 = 0
    public var updated_at: NSDate
    public var belongs_to_event: Event?
    public var belongs_to_invitation_type: InvitationType?
    public var belongs_to_user: User?
    
    override init () {
        self.id = 0
        self.guest_user_id = 0
        self.created_at = NSDate.init()
        self.updated_at = NSDate.init()
        self.email = ""
    }
    
    //Dao
    class func saveInvitation(context: NSManagedObjectContext, invitation: InvitationBean){
        let invitationObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Invitation", into: context)
        
        invitationObj.setValue(invitation.id, forKey: "id")
        invitationObj.setValue(invitation.invitation_id, forKey: "invitation_id")
        invitationObj.setValue(invitation.invitation_type_id, forKey: "invitation_type_id")
        invitationObj.setValue(invitation.event_id, forKey: "event_id")
        invitationObj.setValue(invitation.host_user_id, forKey: "host_user_id")
        invitationObj.setValue(invitation.guest_user_id, forKey: "guest_user_id")
        invitationObj.setValue(invitation.email.lowercased(), forKey: "email")
        invitationObj.setValue(invitation.created_at, forKey: "created_at")
        invitationObj.setValue(invitation.updated_at, forKey: "updated_at")
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
        
        invitationBean.id = object.value(forKey: "id") as! Int16
        invitationBean.invitation_id = object.value(forKey: "invitation_id") as! Int16
        invitationBean.created_at = object.value(forKey: "created_at") as! NSDate
        invitationBean.updated_at = object.value(forKey: "updated_at") as! NSDate
        invitationBean.email = object.value(forKey: "email") as! String
        invitationBean.event_id = object.value(forKey: "event_id") as! Int16
        invitationBean.host_user_id = object.value(forKey: "host_user_id") as! Int16
        invitationBean.guest_user_id = object.value(forKey: "guest_user_id") as! Int16
        invitationBean.invitation_type_id = object.value(forKey: "invitation_type_id") as! Int16
        
        return invitationBean
    }
    
    func validateCreateInvitation() -> String{
        let message = ""
        
        return message
    }
}
