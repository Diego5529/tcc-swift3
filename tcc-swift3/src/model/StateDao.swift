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
    
    class func selectStateById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from states where id = ?", values: [1])
            
            while rs.next() {
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
