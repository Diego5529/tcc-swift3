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
    
    class func selectCountryById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from countries where id = ?", values: [1])
            
            while rs.next() {
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
