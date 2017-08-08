//
//  CityDao.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 31/07/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class CityDao : NSObject {
    
    class func insertOrReplaceCity(db: FMDatabase, city: CityBean) -> Bool {
        
        var success = false
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO cities (created_at, ddd, id, name, state_id, updated_at, zip_code) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: city)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                let isLast = (count == properties.count-1)
                
                print("\(property.label!) = \(property.value)")
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = city.value(forKey: propertyName)
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
    
    class func selectCityById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from cities where id = ?", values: [1])
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: CityBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllCities(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from cities", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: CityBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    } 
}
