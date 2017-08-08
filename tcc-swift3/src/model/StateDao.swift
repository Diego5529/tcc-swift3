//
//  StateDao.swift
//  tcc-swift3
//
//  Created by macmini on 02/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class StateDao : NSObject {
    
    class func insertOrReplaceState(db: FMDatabase, state: StateBean) -> Bool {
        
        var success = false
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO states (country_id, created_at, id, initials, name, updated_at) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: state)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                let isLast = (count == properties.count-1)
                
                print("\(property.label!) = \(property.value)")
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = state.value(forKey: propertyName)
                dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                count += 1
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
            
        } catch is Error {
            
        }
        
        return success
    }
    
    class func getCityMaxId(db: FMDatabase) -> Int16 {
        
        var max = Int16()
        
        do {
            let rs = try db.executeQuery("select max(id) from cities", values: nil)
            
            if rs.next() {
                max = Int16(rs.int(forColumnIndex: 0))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return max
    }
    
    class func selectStateById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from states where id = ?", values: [1])
            
            if rs.next() {
                array .add(Database.serializer(rs: rs, obj: StateBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllStates(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from states", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: StateBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    } 
}
