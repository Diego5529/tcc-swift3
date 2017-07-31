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
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databaseName)
        
        let database = FMDatabase(path: fileURL.absoluteString)!
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        
        do {
            try database.executeUpdate("create table test(x text, y text, z text)", values: nil)
            try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["a", "b", "c"])
            try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["e", "f", "g"])
            
            let rs = try database.executeQuery("select x, y, z from test", values: nil)
            while rs.next() {
                if let x = rs.string(forColumn: "x"), let y = rs.string(forColumn: "y"), let z = rs.string(forColumn: "z") {
                    print("x = \(x); y = \(y); z = \(z)")
                }
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
    }
}
