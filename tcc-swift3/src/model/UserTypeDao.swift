//
//  UserTypeDao.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 07/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class UserTypeDao : NSObject {
    
    class func insertOrReplaceUserType(db: FMDatabase, userType: UserTypeBean) -> Bool {
        
        var success = false
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO user_types (created_at, id, long_description, short_description, title, updated_at) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: userType)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                let isLast = (count == properties.count-1)
                
                print("\(property.label!) = \(property.value)")
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = userType.value(forKey: propertyName)
                dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                count += 1
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
            
        } catch is Error {
            
        }
        
        return success
    }
    
    class func selectUserTypeById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from user_types where id = ?", values: [1])
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: UserTypeBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllUserTypes(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from user_types", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: UserTypeBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
}
