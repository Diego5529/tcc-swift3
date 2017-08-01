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
    
    class func serializer(byResultset rs: FMResultSet) -> NSObject {
        let obj =  NSObject()
        for i in 0 ..< rs.columnCount() {
            let column: String = rs.columnName(for: i)
            let value: Any? = rs.object(forColumnIndex: i)
            
            do {
                if !(value is NSNull) {
                    if (value is String) {
                        obj.setValue(value, forKey: column)
                    } else {
                        obj.setValue(value, forKey: column)
                    }
                }else{
                   obj.setValue(value, forKey: column)
                }
            } catch is exception {
                print("%s", exception())
            }
        }
        
        return obj
    }
    
    /*func serialize(byResultset rs: FMResultSet) -> CityBean {
        let cityBean = CityBean()
        
        cityBean.id = Int16(rs.int(forColumn: "id"))
        cityBean.name = rs.string(forColumn: "name")
        cityBean.zip_code = rs.string(forColumn: "zip_code")
        cityBean.state_id = Int16(rs.int(forColumn: "state_id"))
        cityBean.ddd = Int16(rs.int(forColumn: "ddd"))
        cityBean.created_at = rs.date(forColumn: "created_at")! as NSDate
        cityBean.updated_at = rs.date(forColumn: "updated_at")! as NSDate
        
        return cityBean
    }*/
}
