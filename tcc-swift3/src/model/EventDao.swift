//
//  EventDao.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 02/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class EventDao : NSObject {
    
    class func insertOrReplaceEvent(db: FMDatabase, event: EventBean) -> Bool {
        
        var success = false
        
        var count: UInt32 = 0
        let properties = class_copyPropertyList(object_getClass(EventBean.self), &count)
        
        for index in 0...count {
            let property1 = property_getName(properties?[Int(index)])
            let result1 = String(cString: property1!)
            print(result1)
        }
        
        do {

            var sqlUpdate = "INSERT OR REPLACE INTO events (id, event_id, title, short_description, long_description, city_id, address, address_complement, number, district, zip_code, latitude, longitude, url_site, facebook_page, initial_date, end_date, initial_hour, end_hour, status, note, archive, event_type_id, use_password, password, confirm_password, min_users, max_users, company_id, created_at, updated_at) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: event)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                let isLast = (count == properties.count-1)
                
                print("\(property.label!) = \(property.value)")
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = event.value(forKey: propertyName)
                dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                count += 1
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
        } catch is Error {
            
        }
        
        return success
    }
    
    class func getEventMaxId(db: FMDatabase) -> Int16 {
        
        var max = Int16()
        
        do {
            let rs = try db.executeQuery("select max(event_id) from events", values: nil)
            
            if rs.next() {
                max = Int16(rs.int(forColumnIndex: 0))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return max
    }
    
    class func selectEventById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from events where id = ?", values: [1])
            
            if rs.next() {
                array .add(Database.serializer(rs: rs, obj: EventBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllEvents(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from events", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: EventBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
}
