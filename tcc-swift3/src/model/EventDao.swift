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
        
        if event.event_id == 0 {
            event.event_id = getEventMaxId(db: db)
        }
        
        do {

            var sqlUpdate = "INSERT OR REPLACE INTO events (address, address_complement, archive, city_id, company_id, confirm_password, created_at, district, end_date, end_hour, event_category_id, event_id, event_type_id, facebook_page, id, initial_date, initial_hour, latitude, long_description, longitude, max_users, min_users, note, number, password, short_description, status, title, updated_at, url_site, use_password, zip_code) VALUES ("
            
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
        } catch {
            print("failed: \(error.localizedDescription)")
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
