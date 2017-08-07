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
    
    class func insertOrReplaceUser(db: FMDatabase, user: UserBean) -> Bool {
        
        var success = false
        
        if user.user_id == 0 {
            user.user_id = self.getUserMaxId(db: db)
        }
        
        user.updated_at = NSDate.init()
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO users ( active, admin, birth_date, created_at, current_sign_in_at, current_sign_in_ip, email, encrypted_password, genre, id, last_name, last_sign_in_at, last_sign_in_ip, long_name, name, phone_number, provider, remember_created_at, reset_password_sent_at, reset_password_token, sign_in_count, token, uid, updated_at, user_id ) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: user)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                print("\(property.label!) = \(property.value)")
                
                if !(property.label == "deviseMinPassword") && !(property.label == "password") && !(property.label == "password_confirmation")  {
                    let isLast = (count == (properties.count-4))
                    
                    propertyName = property.label!
                    sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                    propertyValue = user.value(forKey: propertyName)
                    dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                    count += 1
                }
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
            
        } catch is Error {
            
        }
        
        return success
    }
    
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
        
        return max + 1
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
