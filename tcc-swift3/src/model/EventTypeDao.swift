//
//  EventTypeDao.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 07/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class EventTypeDao : NSObject {
    
    class func insertOrReplaceEventType(db: FMDatabase, eventType: EventTypeBean) -> Bool {
        
        var success = false
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO event_types (created_at, id, long_description, short_description, title, updated_at) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: eventType)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                let isLast = (count == properties.count-1)
                
                print("\(property.label!) = \(property.value)")
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = EventType.value(forKey: propertyName)
                dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                count += 1
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
            
        } catch is Error {
            
        }
        
        return success
    }
    
    class func selectEventTypeById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from event_typea where id = ?", values: [1])
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: EventTypeBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllEventTypes(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from event_typea", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: EventTypeBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
}
