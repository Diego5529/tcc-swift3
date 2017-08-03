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
    
    class func insertEvent(db: FMDatabase, event: EventBean) -> Bool {
        
        var success = false
        
        var count: UInt32 = 0
        let properties = class_copyPropertyList(object_getClass(EventBean.self), &count)
        
        for index in 0...count {
            let property1 = property_getName(properties?[Int(index)])
            let result1 = String(cString: property1!)
            print(result1)
        }
        
        do {

            
            let string = #keyPath(EventBean.title)
            let arguments: [AnyHashable: Any] = ["identifier": (""), "name": string, "date": string, "comment": string ]
            try success = db.executeUpdate("", withParameterDictionary: arguments)
            
            let rs = try db.executeQuery("select max(event_id) from events", values: nil)
            
            if rs.next() {
                Int16(rs.int(forColumnIndex: 0))
            }
            
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
