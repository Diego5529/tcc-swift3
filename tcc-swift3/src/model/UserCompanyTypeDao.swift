//
//  UserCompanyTypeDao.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 07/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class UserCompanyTypeDao : NSObject {
    
    class func insertOrReplaceUser(db: FMDatabase, userCompanyType: UserCompanyTypeBean) -> Bool {
        
        var success = false
        
        if userCompanyType.user_company_type_id == 0 {
            userCompanyType.user_company_type_id = self.getUserCompanyTypeMaxId(db: db)
        }
        
        userCompanyType.updated_at = NSDate.init()
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO user_company_types ( active, admin, company_id, created_at, id, updated_at, user_company_type_id, user_id, user_type_id ) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: userCompanyType)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                print("\(property.label!) = \(property.value)")
                
                let isLast = (count == (properties.count-1))
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = userCompanyType.value(forKey: propertyName)
                dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                count += 1
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
            
        } catch is Error {
            print(Error.self)
        }
        
        return success
    }
    
    class func getUserCompanyTypeMaxId(db: FMDatabase) -> Int16 {
        
        var max = Int16()
        
        do {
            let rs = try db.executeQuery("select max(user_company_type_id) from user_company_types", values: nil)
            
            if rs.next() {
                max = Int16(rs.int(forColumnIndex: 0))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return max + 1
    }
    
    class func getUserByToken(db: FMDatabase, token: String) -> UserCompanyTypeBean {
        
        var user = UserCompanyTypeBean()
        
        do {
            let rs = try db.executeQuery("select * from user_company_types where token = ?", values: [token])
            
            if rs.next() {
                user = Database.serializer(rs: rs, obj: UserCompanyTypeBean()) as! UserCompanyTypeBean
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return user
    }
    
    class func getUserByEmail(db: FMDatabase, email: String) -> UserCompanyTypeBean {
        
        var user = UserCompanyTypeBean()
        
        do {
            let rs = try db.executeQuery("select * from user_company_types where email = ?", values: [email])
            
            if rs.next() {
                user = Database.serializer(rs: rs, obj: UserCompanyTypeBean()) as! UserCompanyTypeBean
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return user
    }
    
    class func selectUserById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from user_company_types where id = ?", values: [id])
            
            if rs.next() {
                array .add(Database.serializer(rs: rs, obj: UserCompanyTypeBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllUserCompanyTypes(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from user_company_types", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: UserCompanyTypeBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
}
