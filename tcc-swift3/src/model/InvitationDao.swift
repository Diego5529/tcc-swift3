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
        
        return max
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
