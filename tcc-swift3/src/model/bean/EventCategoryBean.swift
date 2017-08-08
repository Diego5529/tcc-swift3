//
//  EventCategoryBean.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 12/06/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ReachabilitySwift
import Crashlytics
import Alamofire

class EventCategoryBean : NSObject {
    
    public var created_at: NSDate
    public var id: Int16
    public var long_description: NSString
    public var short_description: NSString
    public var title: NSString
    public var updated_at: NSDate
    
    override init () {
        self.id = 0
        self.long_description = ""
        self.short_description = ""
        self.title = ""
        self.created_at = NSDate.init()
        self.updated_at = NSDate.init()
    }
    
    //EventCategory
    class func listAllEventCategories(db: Database) {
        if (Connection.isReachable()){
            
            let stringURL = String.urlPath() .appending("/event_category/event_categories")
            
            Alamofire.request(stringURL).responseJSON { response in
                debugPrint(response)
                if (response.error != nil){
                    print(response.error as Any)
                }else{
                    if let jsonResult = response.result.value {
                        print("JSON: \(jsonResult)")
                        
                        do{
                            if (jsonResult is NSArray){
                                print(jsonResult)
                            }else if(jsonResult is NSDictionary){
                                print(jsonResult)
                                
                                if ((jsonResult as AnyObject).count >= 1){
                                    
                                    if ((jsonResult as AnyObject).count == 1){
                                        
                                        for (key, value) in jsonResult as! NSDictionary {
                                            if (value is String && key as! Bool){
                                                print(value, key)
                                            }else{
                                                let array = value as! NSArray
                                                
                                                for dic in array  {
                                                    let obj = EventCategoryBean()
                                                    
                                                    self.setValuesByJSON(result: dic as! NSDictionary, obj: obj)
                                                    
                                                    do {
                                                        //save user on db
                                                        try EventCategoryDao.insertOrReplaceEventCategory(db: db.fmDatabase, eventCategory: obj)
                                                        
                                                    }catch{
                                                        //self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                                    }
                                                }
                                            }
                                        }
                                    }else{
                                        
                                        let obj = EventCategoryBean()
                                        
                                        self.setValuesByJSON(result: jsonResult as! NSDictionary, obj: obj)
                                        
                                        do {
                                            //save user on db
                                            try EventCategoryDao.insertOrReplaceEventCategory(db: db.fmDatabase, eventCategory: obj)
                                            
                                        }catch{
                                            //self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                        }
                                    }
                                }
                            }else if(jsonResult is NSString){
                                print(jsonResult)
                            }
                        } catch let error {
                            print("%@", error)
                        }
                    }
                }
            }
        }
    }
    //
    
    class func setValuesByJSON (result: NSDictionary, obj: EventCategoryBean){
        for (key, value) in result {
            print("Property: \"\(key as! String)\" Value: \"\(value )\" ")
            let keys = key as! NSString
            if ((value is String || value is Int16) && !keys.contains("_at"))  {
                obj.setValue(value, forKey:key as! String)
            }
        }
    }
}
