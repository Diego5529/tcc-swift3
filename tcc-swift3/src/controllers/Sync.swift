//
//  Sync.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 01/06/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import ReachabilitySwift
import Crashlytics
import Alamofire

class Sync : NSObject {
    
    var urlApi: NSString = ""
    var delegate: AppDelegate!
    var urlPath: NSString = ""
    var viewController: UIViewController!
    
    override init () {
        urlApi = ""
        
        delegate = UIApplication.shared.delegate as! AppDelegate
    
        urlPath = "http://localhost:3000/api"
        
        super.init()
    }
    
    //User
    func getUserEmailOrID(user: UserBean, email: String, id: Int16) {
        
        if (Connection.isReachable()){
            
            let stringURL = urlPath .appending("/user/user_by_email")
            
            Alamofire.request(stringURL, parameters: ["email" : email.lowercased()]).responseJSON { response in
                debugPrint(response)
                if (response.error != nil){
                    print(response.error as Any)
                    self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                }else{
                    if let jsonResult = response.result.value {
                        print("JSON: \(jsonResult)")
                        
                        do{
                            if (jsonResult is NSArray){
                                print(jsonResult)
                                
                                self.showErrosFullmessages(array: jsonResult as! NSArray)
                            }else if(jsonResult is NSDictionary){
                                print(jsonResult)
                                
                                let userObj = UserBean()
                                
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
                                        
                                        self.setValuesByJSON(result: jsonResult as! NSDictionary, obj: userObj, id_local: user.user_id)
                                        
                                        do {
                                            if(UserDao.insertOrReplaceUser(db: self.delegate.db.fmDatabase, user: userObj)){
                                                print("User updated")
                                            }
                                        }catch{
                                            self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
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
    
    func setValuesByJSON (result: NSDictionary, obj: AnyObject, id_local: Int16){
        for (key, value) in result {
            print("Property: \"\(key as! String)\" Value: \"\(value )\" ")
            let keys = key as! NSString
            if ((value is String || value is Int16) && !keys.contains("_at"))  {
                obj.setValue(value, forKey:key as! String)
            }
        }
    }
    //
    
    //Company
    func sendCompany(company: CompanyBean, method: String) {
        if (Connection.isReachable()){
            
            let stringURL = urlPath .appendingFormat("/company/%@", method)
            
            let url = URL(string: stringURL as String)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            var companyID = ""
            
            if (company.id > 0) {
                companyID = String(format: "&company[id]=%i", company.id)
            }
            
            let bodyData = String(format: "company[title]=%@&company[short_description]=%@&company[long_description]=%@&company[min_users]=%i&company[max_users]=%i%@", company.title!, company.short_description!, company.long_description!, company.min_users, company.max_users, companyID)
            
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            
            Alamofire.request(request).responseJSON { response in
                debugPrint(response)
                if (response.error != nil){
                    print(response.error as Any)
                    self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                }else{
                    if let jsonResult = response.result.value {
                        print("JSON: \(jsonResult)")
                        
                        do{
                            if (jsonResult is NSArray){
                                print(jsonResult)
                                
                                self.showErrosFullmessages(array: jsonResult as! NSArray)
                            }else if(jsonResult is NSDictionary){
                                print(jsonResult)
                                
                                if ((jsonResult as AnyObject).count >= 1){
                                    
                                    if ((jsonResult as AnyObject).count == 1){
                                        
                                        for (key, value) in jsonResult as! NSDictionary {
                                            if (value is String && key as! Bool){
                                                self.showMessage(message: value as! String, title: "", cancel: "")
                                            }else{
                                                let array = value as! NSArray
                                                
                                                for dic in array  {
                                                    print(dic)
                                                    do {
                                                    }catch{
                                                        self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                                    }
                                                }
                                            }
                                        }
                                    }else{
                                        
                                        self.setValuesByJSON(jsonResult: jsonResult as! NSDictionary, obj: company)
                                        
                                        do {
                                            if(CompanyDao.insertOrReplaceCompany(db: self.delegate.db.fmDatabase, company: company)){
                                                print("Updated Company")
                                            }
                                        }catch{
                                            self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                        }
                                    }
                                }
                            }else if(jsonResult is NSString){
                                print(jsonResult)
                            }
                        } catch let error {
                            print("%@", error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    //
    
    //Event
    func sendEvent(event: EventBean, method: String) {
        if (Connection.isReachable()){
            
            let stringURL = urlPath .appendingFormat("/event/%@", method)
            
            let url = URL(string: stringURL as String)!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            var companyID = ""
            
            if (event.id > 0) {
                companyID = String(format: "&event[id]=%i", event.id)
            }
            
            let bodyData = String(format: "event[title]=%@&event[short_description]=%@&event[long_description]=%@&event[min_users]=%i&company[max_users]=%i%@", event.title!, event.short_description!, event.long_description!, event.min_users, event.max_users, companyID)
            
            request.httpBody = bodyData.data(using: String.Encoding.utf8)
            
            Alamofire.request(request).responseJSON { response in
                debugPrint(response)
                if (response.error != nil){
                    print(response.error as Any)
                    self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                }else{
                    if let jsonResult = response.result.value {
                        print("JSON: \(jsonResult)")
                        
                        do{
                            if (jsonResult is NSArray){
                                print(jsonResult)
                                
                                self.showErrosFullmessages(array: jsonResult as! NSArray)
                            }else if(jsonResult is NSDictionary){
                                print(jsonResult)
                                
                                if ((jsonResult as AnyObject).count >= 1){
                                    
                                    if ((jsonResult as AnyObject).count == 1){
                                        
                                        for (key, value) in jsonResult as! NSDictionary {
                                            if (value is String && key as! Bool){
                                                self.showMessage(message: value as! String, title: "", cancel: "")
                                            }else{
                                                let array = value as! NSArray
                                                
                                                for dic in array  {
                                                    print(dic)
                                                    do {
                                                    }catch{
                                                        self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                                    }
                                                }
                                            }
                                        }
                                    }else{
                                        
                                        self.setValuesByJSONEvent(jsonResult: jsonResult as! NSDictionary, obj: event)
                                        
                                        do {
                                            if(EventDao.insertOrReplaceEvent(db: self.delegate.db.fmDatabase, event: event)){
                                                print("Updated Event")
                                            }
                                        }catch{
                                            self.showMessage(message: "Can not connect, check your connection.", title: "Error", cancel: "")
                                        }
                                    }
                                }
                            }else if(jsonResult is NSString){
                                print(jsonResult)
                            }
                        } catch let error {
                            print("%@", error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    //
    
    func setValuesByJSONEvent(jsonResult: NSDictionary, obj: EventBean){
        for (key, value) in jsonResult {
            print("Property: \"\(key as! String)\" Value: \"\(value )\" ")
            
            obj.setValue(value, forKey:key as! String);
        }
    }
    
    func setValuesByJSON (jsonResult: NSDictionary, obj: CompanyBean){
        for (key, value) in jsonResult {
            print("Property: \"\(key as! String)\" Value: \"\(value )\" ")
            
            obj.setValue(value, forKey:key as! String);
        }
    }
    
    //Sync
    class func syncTables(db: Database) {
        EventTypeBean.listAllEventTypes(db: db)
        EventCategoryBean.listAllEventCategories(db: db)
        UserTypeBean.listAllUserTypes(db: db)
        InvitationTypeBean.listAllInvitationType(db: db)
        
        CountryBean.listAllCountry(db: db)
        StateBean.listAllStates(db: db)
        CityBean.listAllCities(db: db)
    }
    //
    
    //Send
    //
    
    //Send User Fabric
    func logUserFabric() {
        if (delegate.loggedUser != nil) {
            Crashlytics.sharedInstance().setUserEmail(delegate.loggedUser.email)
            Crashlytics.sharedInstance().setUserIdentifier(delegate.loggedUser.token as String?)
            Crashlytics.sharedInstance().setUserName(delegate.loggedUser.name)
            
            Answers.logLogin(withMethod: "API",
                             success: true,
                             customAttributes: [
                                "email": delegate.loggedUser.email as String,
                                "name": delegate.loggedUser.name! as String
                ])
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
    
    //AlertView
    func showMessage(message: String, title: String, cancel: String){
        if (self.viewController != nil) {
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
}
