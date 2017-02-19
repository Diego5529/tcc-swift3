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
import ReachabilitySwift

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

    //Login
    func signIn() {
        print("SignIn")
        
        if (delegate.reachability?.isReachable)!{
            let stringURL = urlPath .appending("/user/sign_in")
            
            let url = URL(string: stringURL)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let bodyData = String(format: "user[email]=%@&user[password]=%@", genericUser!.email!, genericUser!.password!)
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil){
                    print(error as Any)
                    self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
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
                                self.genericUser?.setValue(value, forKey:key as! String);
                            }
                            
                            print (self.genericUser?.token as Any)
                            
                            do {
                                try self.context.save()
                                self.defaults.set(self.genericUser?.token, forKey: "loggedUser")
                                
                                self.showInitialPage();
                                
                            }catch{
                                self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
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
        }else{
            self.showMessage(message: "Check your internet connection.", title: "Error", cancel: "")
        }
    }
    
    //Create Account
    func signUp(){
        print("SignUp")
        
        if (delegate.reachability?.isReachable)!{
            
            let stringURL = urlPath .appending("/user/sign_up")
            
            let url = URL(string: stringURL as String)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let bodyData = String(format: "user[name]=%@&user[email]=%@&user[password]=%@&user[password_confirmation]=%@", (genericUser?.name!)!, (genericUser?.email!)!, (genericUser?.password!)!, (genericUser?.password_confirmation!)!)
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil){
                    print(error as Any)
                }else{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        if (jsonResult is NSArray){
                            print(jsonResult)
                        }
                        else if(jsonResult is NSDictionary){
                            print(jsonResult)
                            
                            let userObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.context)
                            if ((jsonResult as AnyObject).count > 1){
                                for (key, value) in jsonResult as! NSDictionary {
                                    print("Property: \"\(key as! String)\" Value: \"\(value as! String)\" ")
                                    
                                    userObj.setValue(value, forKey:key as! String);
                                }
                                
                                do {
                                    try self.context.save()
                                }catch{
                                    print("Salvou")
                                }
                            }else{
                                for (key, value) in jsonResult as! NSDictionary {
                                    print("Property: \"\(key as! String)\" Value: \"\(value)\" ")
                                }
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
    
    //show Initial page
    func showInitialPage(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerScene1") as UIViewController
        self.viewController.present(vc, animated: true, completion: nil)
    }
    
    //AlertView
    func showMessage(message: String, title: String, cancel: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if cancel.characters.count > 0 {
            let DestructiveAction = UIAlertAction(title: cancel, style: UIAlertActionStyle.destructive) {
                (result : UIAlertAction) -> Void in
                print("Destructive")
            }
            
            alertController.addAction(DestructiveAction)
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        self.viewController.present(alertController, animated: true, completion: nil)
    }
}
