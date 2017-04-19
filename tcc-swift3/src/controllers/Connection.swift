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
import Crashlytics

class Connection : NSObject {

    var urlApi: NSString = ""
    var delegate: AppDelegate!
    var context: NSManagedObjectContext!
    var urlPath: NSString = ""
    var viewController: UIViewController!
    var person: [NSManagedObject] = []
    
    override init () {        
        urlApi = ""
        
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        context = self.delegate.managedObjectContext
        
        urlPath = "http://localhost:3000/api"
        
        super.init()
    }

    //Login
    func signIn() {
        print("SignIn")
        
        if (delegate.reachability?.isReachable)!{
            let vc = viewController as! ViewController
            
            activityChangeStatus(activityView: vc.activityView, activityIndicator: vc.activityIndicator, hidden: false)
            
            let stringURL = urlPath .appending("/user/sign_in")
            
            let url = URL(string: stringURL)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let bodyData = String(format: "user[email]=%@&user[password]=%@", delegate.genericUser!.email!, delegate.genericUser!.password!)
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
                            
                            self.showErrosFullmessages(array: jsonResult as! NSArray)
                            
                        }else if(jsonResult is NSDictionary){
                            print(jsonResult)
                            
                            let userObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.context)
                            
                            if ((jsonResult as AnyObject).count >= 1){
                                
                                if ((jsonResult as AnyObject).count == 1){
                                    let mutable = "" as NSMutableString
                                    let mutable2 = "" as NSMutableString
                                    
                                    for (key, value) in jsonResult as! NSDictionary {
                                        if (value is String){
                                            self.showMessage(message: value as! String, title: "", cancel: "")
                                        }else{
                                            let array = value as! NSArray
                                            
                                            let obj = array .object(at: 0)
                                            
                                            let title = key as! String
                                            
                                            mutable.append(obj as! String)
                                            mutable2.append(title.capitalized)
                                        }
                                    }
                                }else{
                            
                                    self.setValuesByJSON(jsonResult: jsonResult as! NSDictionary, userObj: userObj)
                                    
                                    do {
                                        //save user on db
                                        try self.context.save()
                                        
                                        //set defaults users
                                        self.delegate.defaults.set(self.delegate.genericUser?.token, forKey: self.delegate.keyDefaultsToken)
                                        
                                        //login with token
                                        self.loginByToken()
                                    }catch{
                                        self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                    }
                                }
                            }
                        }else if(jsonResult is NSString){
                            print(jsonResult)
                        }
                    }catch {
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
                
                self.activityChangeStatus(activityView: vc.activityView, activityIndicator: vc.activityIndicator, hidden: true)
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
            let vc = viewController as! ViewController
            
            activityChangeStatus(activityView: vc.activityView, activityIndicator: vc.activityIndicator, hidden: false)
            
            let stringURL = urlPath .appending("/user/sign_up")
            
            let url = URL(string: stringURL as String)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let bodyData = String(format: "user[name]=%@&user[email]=%@&user[password]=%@&user[password_confirmation]=%@", (delegate.genericUser?.name!)!, (delegate.genericUser?.email!)!, (delegate.genericUser?.password!)!, (delegate.genericUser?.password_confirmation!)!)
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil){
                    print(error as Any)
                    self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                }else{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        if (jsonResult is NSArray){
                            self.showErrosFullmessages(array: jsonResult as! NSArray)
                        }
                        else if(jsonResult is NSDictionary){
                            print(jsonResult)
                            
                            let userObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.context)
                            
                            if ((jsonResult as AnyObject).count >= 1){
                                
                                if ((jsonResult as AnyObject).count == 1){
                                    let mutable = "" as NSMutableString
                                    let mutable2 = "" as NSMutableString
                                    
                                    for (key, value) in jsonResult as! NSDictionary {
                                        let array = value as! NSArray
                                        
                                        let obj = array .object(at: 0)
                                        
                                        let title = key as! String
                                        
                                        mutable.append(obj as! String)
                                        mutable2.append(title.capitalized)
                                        
                                    }
                                    
                                    self.showMessage(message: mutable as String, title: mutable2 as String, cancel: "")
                                }else{
                                
                                    self.setValuesByJSON(jsonResult: jsonResult as! NSDictionary, userObj: userObj)
                                    
                                    do {
                                        try self.context.save()
                                        OperationQueue.main.addOperation {
                                            if (self.delegate.loggedUser != nil) {
                                                Answers.logSignUp(withMethod: "API",
                                                                 success: true,
                                                                 customAttributes: [
                                                                    "email": self.delegate.genericUser?.email! as! NSString,
                                                                    "name": self.delegate.genericUser?.name! as! NSString
                                                    ])
                                            }
                                            
                                            if ((self.viewController) != nil) {
                                                let vc = self.viewController as! ViewController;
                                                vc.signInEmailTextField.text = self.delegate.genericUser?.email as String?
                                                vc.showSignInView()
                                            }
                                        }
                                    }catch{
                                        print("Salvou")
                                    }
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
                self.activityChangeStatus(activityView: vc.activityView, activityIndicator: vc.activityIndicator, hidden: true)
            })
            
            task.resume()
        }
    }
    
    //Send Reset Password
    func resetPassword() {
        print("Reset Password")
        
        if (delegate.reachability?.isReachable)!{
            let vc = viewController as! ViewController
            
            activityChangeStatus(activityView: vc.activityView, activityIndicator: vc.activityIndicator, hidden: false)
            
            let stringURL = urlPath .appending("/user/reset_password")
            
            let url = URL(string: stringURL)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let bodyData = String(format: "user[email]=%@", delegate.genericUser!.email!)
            
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil){
                    print(error as Any)
                    self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                }else{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        print(jsonResult)
                        
                        if (jsonResult is NSArray){
                            print(jsonResult)
                            
                            self.showErrosFullmessages(array: jsonResult as! NSArray)
                            
                        }else if(jsonResult is NSDictionary){
                            print(jsonResult)
                            
                            let userObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.context)
                            
                            if ((jsonResult as AnyObject).count >= 1){
                                
                                if ((jsonResult as AnyObject).count == 1){
                                    let mutable = "" as NSMutableString
                                    let mutable2 = "" as NSMutableString
                                    
                                    for (key, value) in jsonResult as! NSDictionary {
                                        if (value is String){
                                            self.showMessage(message: value as! String, title: "", cancel: "")
                                        }else{
                                            let array = value as! NSArray
                                            
                                            let obj = array .object(at: 0)
                                            
                                            let title = key as! String
                                            
                                            mutable.append(obj as! String)
                                            mutable2.append(title.capitalized)
                                        }
                                    }
                                }else{
                                    
                                    self.setValuesByJSON(jsonResult: jsonResult as! NSDictionary, userObj: userObj)
                                    
                                    do {
                                        //save user on db
                                        try self.context.save()
                                    }catch{
                                        self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                    }
                                }
                            }
                        }else if(jsonResult is NSString){
                            print(jsonResult)
                        }
                    }catch {
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
                
                self.activityChangeStatus(activityView: vc.activityView, activityIndicator: vc.activityIndicator, hidden: true)
            })
            
            task.resume()
        }else{
            self.showMessage(message: "Check your internet connection.", title: "Error", cancel: "")
        }
    }
    
    //Create Account
    func updatePassword(){
        print("UpdatePassword")
        
        if (delegate.reachability?.isReachable)!{
            let vc = viewController as! ViewController
            
            activityChangeStatus(activityView: vc.activityView, activityIndicator: vc.activityIndicator, hidden: false)
            
            let stringURL = urlPath .appending("/user/update_password")
            
            let url = URL(string: stringURL as String)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let bodyData = String(format: "user[reset_password_token]=%@&user[password]=%@&user[password_confirmation]=%@", (delegate.genericUser?.token!)!, (delegate.genericUser?.password!)!, (delegate.genericUser?.password_confirmation!)!)
            request.httpBody = bodyData.data(using: String.Encoding.utf8);
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if (error != nil){
                    print(error as Any)
                    self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                }else{
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        print(jsonResult)
                        
                        if (jsonResult is NSArray){
                            print(jsonResult)
                            
                            self.showErrosFullmessages(array: jsonResult as! NSArray)
                            
                        }else if(jsonResult is NSDictionary){
                            print(jsonResult)
                            
                            let userObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.context)
                            
                            if ((jsonResult as AnyObject).count >= 1){
                                
                                if ((jsonResult as AnyObject).count == 1){
                                    let mutable = "" as NSMutableString
                                    let mutable2 = "" as NSMutableString
                                    
                                    for (key, value) in jsonResult as! NSDictionary {
                                        if (value is String){
                                            self.showMessage(message: value as! String, title: "", cancel: "")
                                        }else{
                                            let array = value as! NSArray
                                            
                                            let obj = array .object(at: 0)
                                            
                                            let title = key as! String
                                            
                                            mutable.append(obj as! String)
                                            mutable2.append(title.capitalized)
                                        }
                                    }
                                }else{
                                    
                                    self.setValuesByJSON(jsonResult: jsonResult as! NSDictionary, userObj: userObj)
                                    
                                    do {
                                        //save user on db
                                        try self.context.save()
                                    }catch{
                                        self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                    }
                                }
                            }
                        }else if(jsonResult is NSString){
                            print(jsonResult)
                        }
                    }catch {
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
                
                self.activityChangeStatus(activityView: vc.activityView, activityIndicator: vc.activityIndicator, hidden: true)
            })
            
            task.resume()
        }
    }
    
    func setValuesByJSON (jsonResult: NSDictionary, userObj: NSManagedObject){
        for (key, value) in jsonResult {
            print("Property: \"\(key as! String)\" Value: \"\(value as! String)\" ")
            
            userObj.setValue(value, forKey:key as! String);
            self.delegate.genericUser?.setValue(value, forKey:key as! String);
        }
    }
    
    //Login User
    func loginByToken() {
        let token = delegate.defaults.string(forKey: delegate.keyDefaultsToken)
        
        if (token != nil && (token?.characters.count)! > 0) {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
            
            fetchRequest.predicate = NSPredicate(format: "token == %@", token!)
            
            do {
                person = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            if (person.count > 0){
                delegate.loggedUser = person.first as! User!
                
                logUserFabric()
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerScene1") as UIViewController
                OperationQueue.main.addOperation {
                    self.viewController.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    //Send User Fabric
    func logUserFabric() {
        if (delegate.loggedUser != nil) {
            Crashlytics.sharedInstance().setUserEmail(delegate.loggedUser.email)
            Crashlytics.sharedInstance().setUserIdentifier(delegate.loggedUser.token as String?)
            Crashlytics.sharedInstance().setUserName(delegate.loggedUser.name)
            
            Answers.logLogin(withMethod: "API",
                                       success: true,
                                       customAttributes: [
                                        "email": delegate.loggedUser.email! as String,
                                        "name": delegate.loggedUser.name! as String
                ])
        }
    }
    
    //Logout User
    func logoutUser(){
        delegate.loggedUser = User();
        delegate.genericUser = UserBean()
        delegate.defaults .set(nil, forKey: delegate.keyDefaultsToken)
        
        showLoginPage()
    }
    
    //show Initial page
    func showInitialPage(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerScene1") as UIViewController
        OperationQueue.main.addOperation {
            self.viewController.present(vc, animated: true, completion: nil)
        }
    }
    
    //showLogginPage
    func showLoginPage(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "viewController") as UIViewController
        OperationQueue.main.addOperation {
            self.viewController.present(vc, animated: true, completion: nil)
        }
    }
    
    //Json Errors full messages
    func showErrosFullmessages(array: NSArray){
        let mutable = "" as NSMutableString
        
        for value in array {
            mutable .appendFormat("\n- %@.\n", value as! String)
        }
        
        self.showMessage(message: mutable as String, title: "Cadastro Inválido!", cancel: "")
    }
    
    //Activity
    func activityChangeStatus(activityView: UIView, activityIndicator: UIActivityIndicatorView, hidden: Bool) {
        activityView.isHidden = hidden
        activityIndicator.isHidden = hidden
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
            if ((self.viewController) != nil && self.viewController is ViewController) {
                let vc = self.viewController as! ViewController;
                vc.signInEmailTextField.text = self.delegate.genericUser?.email as String?
                if (vc.currentStatus != ViewController.ksignIn){
                    vc.showSignInView()
                }
            }
        }
        
        alertController.addAction(okAction)
        OperationQueue.main.addOperation {
            self.viewController.present(alertController, animated: false, completion: nil)
        }
    }
}
