//
//  CountryDao.swift
//  tcc-swift3
//
//  Created by macmini on 02/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class CountryDao : NSObject {
    
    class func insertOrReplaceCountry(db: FMDatabase, country: CountryBean) -> Bool {
        
        var success = false
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO countries (created_at, id, initials, name, updated_at) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: country)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                let isLast = (count == properties.count-1)
                
                print("\(property.label!) = \(property.value)")
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = country.value(forKey: propertyName)
                dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                count += 1
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
            
        } catch is Error {
            
        }
        
        return success
    }
    
    class func selectCountryById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from countries where id = ?", values: [1])
            
            if rs.next() {
                array .add(Database.serializer(rs: rs, obj: CountryBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllCountries(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from countries", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: CountryBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    } 
}
