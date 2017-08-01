//
//  Database.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 30/07/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import UIKit
import FMDB

class Database : NSObject {
    var fmDatabase: FMDatabase!
    var fmDatabaseQueue: FMDatabaseQueue!
    
    override init () {
        
        super.init()
    }
    
    func createAndOpenDatabase(databaseName: String)  {
        let path: String = "/Documents/" + (databaseName)
        let databasePath: String = NSHomeDirectory() + (path)
        let fileExists: Bool = FileManager.default.fileExists(atPath: databasePath)
        
        if !fileExists {
            copiaDatabase()
            
            fmDatabase = FMDatabase(path: databasePath)!
        }else{
            fmDatabase = FMDatabase(path: databasePath)!
        }
        guard fmDatabase.open() else {
            print("Unable to open database")
            return
        }
        
        do {
            //try database.executeUpdate("create table test(x text, y text, z text)", values: nil)
//            try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["a", "b", "c"])
//            try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["e", "f", "g"])
            
            let rs = try fmDatabase.executeQuery("select * from cities", values: nil)
            let array = NSMutableArray()
            while rs.next() {
                array .add((serializer(byResultset: rs, obj: CityBean()) as! CityBean))
            }
//            print((array .object(at: 0)).self)
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
//        fmDatabase.close()
    }
    
    func serializer(byResultset rs: FMResultSet, obj: AnyObject) -> AnyObject {

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
    
    func copiaDatabase() {
        let databaseFileOrigem: String? = Bundle.main.path(forResource: "tcc-swift3", ofType: "db")
        
        if databaseFileOrigem != nil {
            let path: String = "/Documents/" + ("tcc-swift3.db")
            let databasePath: String = NSHomeDirectory() + path
            let data = NSData(contentsOfFile: databaseFileOrigem!)
            data?.write(toFile: databasePath, atomically: true)
        }
    }

}
