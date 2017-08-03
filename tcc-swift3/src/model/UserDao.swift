//
//  UserDao.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 02/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class UserDao : NSObject {
    
    class func getUserMaxId(db: FMDatabase) -> Int16 {
        
        var max = Int16()
        
        do {
            let rs = try db.executeQuery("select max(user_id) from users", values: nil)
            
            if rs.next() {
                max = Int16(rs.int(forColumnIndex: 0))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return max
    }
    
    class func getUserByToken(db: FMDatabase, token: String) -> UserBean {
        
        var user = UserBean()
        
        do {
            let rs = try db.executeQuery("select * from users where token = ?", values: [token])
            
            if rs.next() {
                user = Database.serializer(rs: rs, obj: UserBean()) as! UserBean
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return user
    }
    
    class func getUserByEmail(db: FMDatabase, email: String) -> UserBean {
        
        var user = UserBean()
        
        do {
            let rs = try db.executeQuery("select * from users where email = ?", values: [email])
            
            if rs.next() {
                user = Database.serializer(rs: rs, obj: UserBean()) as! UserBean
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return user
    }
    
    class func selectUserById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from users where id = ?", values: [id])
            
            if rs.next() {
                array .add(Database.serializer(rs: rs, obj: UserBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllUsers(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from users", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: UserBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
}
