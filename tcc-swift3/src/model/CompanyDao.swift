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
    
    class func insertOrReplaceCompany(db: FMDatabase, company: CompanyBean) -> Bool {
        
        var success = false
        
        if company.company_id == 0 {
            company.company_id = self.getCompanyMaxId(db: db)
        }
        
        company.updated_at = NSDate.init()
        
        do {
            
            var sqlUpdate = "INSERT OR REPLACE INTO companies ( company_id, created_at, id, long_description, max_users, min_users, short_description, title, updated_at ) VALUES ("
            
            var dictionaryParams = [AnyHashable: Any]()
            var propertyValue: Any?
            var propertyName: String = ""
            
            let pokeMirror = Mirror(reflecting: company)
            let properties = pokeMirror.children
            
            var count = 0 as IntMax
            for property in properties {
                print("\(property.label!) = \(property.value)")
                
                let isLast = (count == (properties.count-1))
                
                propertyName = property.label!
                sqlUpdate = sqlUpdate + (" :\(propertyName) \(isLast ? "" : ",")")
                propertyValue = company.value(forKey: propertyName)
                dictionaryParams[propertyName] = (propertyValue == nil ? NSNull() : propertyValue)
                count += 1
            }
            
            sqlUpdate = sqlUpdate + (")")
            
            success = db.executeUpdate(sqlUpdate, withParameterDictionary: dictionaryParams)
            
        } catch is Error {
            
        }
        
        return success
    }
    
    class func getCompanyMaxId(db: FMDatabase) -> Int16 {
        
        var max = Int16()
        
        do {
            let rs = try db.executeQuery("select max(company_id) from companies", values: nil)
            
            if rs.next() {
                max = Int16(rs.int(forColumnIndex: 0))
            }
            
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        return max + 1
    }
    
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
