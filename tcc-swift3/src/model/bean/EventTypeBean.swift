//
//  EventTypeBean.swift
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

class EventTypeBean : NSObject {
    
    //EventType
    class func listAllEventTypes(context: NSManagedObjectContext) {
        if (Connection.isReachable()){
            
            let stringURL = String.urlPath() .appending("/event_type/event_types")
            
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
                                                    let cityObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "EventType", into: context)
                                                    
                                                    self.setValuesByJSON(result: dic as! NSDictionary, obj: cityObj)
                                                    
                                                    do {
                                                        //save user on db
                                                        try context.save()
                                                        
                                                        let select = NSFetchRequest<NSFetchRequestResult>(entityName: "EventType")
                                                        
                                                        do {
                                                            let results = try context.fetch(select)
                                                            //let cities: NSMutableDictionary = [:]
                                                            
                                                            if results.count > 0 {
                                                                print(results)
                                                            }
                                                        }catch{
                                                            
                                                        }
                                                    }catch{
                                                        //self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                                    }
                                                }
                                            }
                                        }
                                    }else{
                                        
                                        let cityObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "EventType", into: context)
                                        
                                        self.setValuesByJSON(result: jsonResult as! NSDictionary, obj: cityObj)
                                        
                                        do {
                                            //save user on db
                                            try context.save()
                                            
                                            let select = NSFetchRequest<NSFetchRequestResult>(entityName: "EventType")
                                            
                                            do {
                                                let results = try context.fetch(select)
                                                //let cities: NSMutableDictionary = [:]
                                                
                                                if results.count > 0 {
                                                    print(results)
                                                }
                                            }catch{
                                                
                                            }
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
    
    class func setValuesByJSON (result: NSDictionary, obj: NSManagedObject){
        for (key, value) in result {
            print("Property: \"\(key as! String)\" Value: \"\(value )\" ")
            let keys = key as! NSString
            if ((value is String || value is Int16) && !keys.contains("_at"))  {
                obj.setValue(value, forKey:key as! String)
            }
        }
    }
}
