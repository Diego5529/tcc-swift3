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
    
    public var created_at: NSDate
    public var email: String
    public var event_id: Int16 = 0
    public var user_id: Int16 = 0
    public var host_user_id: Int16 = 0
    public var id: Int16 = 0
    public var invitation_id: Int16 = 0
    public var invitation_type_id: Int16 = 0
    public var updated_at: NSDate
    
    override init () {
        self.id = 0
        self.user_id = 0
        self.created_at = NSDate.init()
        self.updated_at = NSDate.init()
        self.email = ""
    }
    
    func validateCreateInvitation() -> String{
        let message = ""
        
        return message
    }
}
