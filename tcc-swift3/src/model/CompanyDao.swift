//
//  CompanyDao.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 02/08/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import FMDB

class CompanyDao : NSObject {
    
    class func selectCompanyById(db: FMDatabase, id: Int16) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from companies where id = ?", values: [1])
            
            if rs.next() {
                array .add(Database.serializer(rs: rs, obj: CompanyBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func selectAllCompanies(db: FMDatabase) -> NSMutableArray {
        
        let array = NSMutableArray()
        
        do {
            let rs = try db.executeQuery("select * from companies", values: nil)
            
            while rs.next() {
                array .add(Database.serializer(rs: rs, obj: CompanyBean()))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return array
    }
}
