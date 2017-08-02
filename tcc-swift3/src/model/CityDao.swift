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
