//
//  Connection.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 05/02/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Connection : NSObject {

    var urlApi: NSString = ""
    var delegate: AppDelegate!
    var defaults: UserDefaults!
    var context: NSManagedObjectContext!
    var urlPath: NSString = ""
    var loggedUser: User!
    var genericUser: UserBean?
    var viewController: UIViewController!
    
    override init () {
        
        self.urlApi = ""
        
        self.delegate = UIApplication.shared.delegate as! AppDelegate
        
        self.defaults = UserDefaults.standard
        
        self.context = self.delegate.managedObjectContext
        
        self.urlPath = "http://localhost:3000/api"
        
        self.genericUser = UserBean()
        
        super.init()
    }

    func signIn() {
        print("SignIn")
        
        /*&
         let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
         let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerScene1") as UIViewController
         self.present(vc, animated: true, completion: nil)
         */
        let stringURL = urlPath .appending("/user/sign_in")
        
        let url = URL(string: stringURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bodyData = String(format: "user[email]=%@&user[password]=%@", genericUser!.email!, genericUser!.password!)
        request.httpBody = bodyData.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if (error != nil){
                print(error as Any)
            }else{
                do{
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    if (jsonResult is NSArray){
                        print(jsonResult)
                    }else if(jsonResult is NSDictionary){
                        print(jsonResult)
                        
                        let user: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.context)
                        
                        for (key, value) in jsonResult as! NSDictionary {
                            print("Property: \"\(key as! String)\" Value: \"\(value as! String)\" ")
                            
                            user.setValue(value, forKey:key as! String);
                        }
                        
                        self.genericUser = user as? User as! UserBean?
                        
                        print (self.genericUser?.token as Any)
                        
                        do {
                            try self.context.save()
                            self.defaults.set(self.genericUser?.token, forKey: "loggedUser")
                            
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerScene1") as UIViewController
                            self.viewController.present(vc, animated: true, completion: nil)
                            
                        }catch{
                        }
                        
                    }else if(jsonResult is NSString){
                        print(jsonResult)
                    }
                    print(jsonResult)
                }catch {
                    //let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    //self.returnTextView.text = String(datastring)
                    print(error)
                    
                    let select = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                    
                    select.returnsObjectsAsFaults = false
                    
                    do {
                        let results = try self.context.fetch(select)
                        
                        if results.count > 0 {
                            print(results.count)
                        }
                    }catch{
                    }
                }
            }
        })
        
        task.resume()
    }
    
}
