//
//  InvitationDao.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 02/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class InvitationDao : NSObject {
    
    class func insertOrReplaceInvitation(db: FMDatabase, invitation: InvitationBean) -> Bool {
        
        var success = false
        
        if invitation.invitation_id == 0 {
            invitation.invitation_id = self.getInvitationMaxId(db: db)
        }
        
        invitation.updated_at = NSDate.init()
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO invitations ( created_at, email, event_id, guest_user_id, host_user_id, id, invitation_id, invitation_type_id, updated_at ) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: invitation)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                print("\(property.label!) = \(property.value)")
                
                let isLast = (count == (properties.count-1))
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = invitation.value(forKey: propertyName)
                dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                count += 1
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
            
        } catch is Error {
            
        }
        
        return success
    }
    
    class func getInvitationMaxId(db: FMDatabase) -> Int16 {
        
        var max = Int16()
        
        do {
            let rs = try db.executeQuery("select max(invitation_id) from invitations", values: nil)
            
            if rs.next() {
                max = Int16(rs.int(forColumnIndex: 0))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return max + 1
    }
    
    
    class func selectInvitationById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from invitations where id = ?", values: [1])
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: InvitationBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllInvitations(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from invitations", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: InvitationBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
}
