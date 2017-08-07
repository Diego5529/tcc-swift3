//
//  UserBean.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 05/02/17.
//  Copyright © 2017 DO. All rights reserved.
//

import Foundation
import CoreData

class UserBean : NSObject {
    
    public var active: Int16 = 1
    public var admin: Bool = false
    public var birth_date: NSDate?
    public var created_at: NSDate = NSDate.init()
    public var current_sign_in_at: NSDate?
    public var current_sign_in_ip: String?
    public var deviseMinPassword = 6
    public var email: String = ""
    public var encrypted_password: String = ""
    public var genre: String?
    public var id: Int16 = 0
    public var last_name: String?
    public var last_sign_in_at: NSDate?
    public var last_sign_in_ip: String?
    public var long_name: String?
    public var name: String?
    public var password: String?
    public var password_confirmation: String?
    public var phone_number: String?
    public var provider: String?
    public var remember_created_at: NSDate?
    public var reset_password_sent_at: NSDate?
    public var reset_password_token: String?
    public var sign_in_count: Int16 = 0
    public var token: String?
    public var uid: String?
    public var updated_at: NSDate = NSDate.init()
    public var user_id: Int16 = 0
    
    //Dao
    class func saveUser(context: NSManagedObjectContext, user: UserBean){
        let userObj: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        userObj.setValue(user.id, forKey: "id")
        userObj.setValue(user.user_id, forKey: "user_id")
        userObj.setValue(user.name, forKey: "name")
        userObj.setValue(user.email, forKey: "email")
        userObj.setValue(user.token, forKey: "token")
    }
    
    class func getMaxUser(context: NSManagedObjectContext) -> Int16 {
        var idMax = 0
        
        let select = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let results = try context.fetch(select)
            
            idMax = results.count + 1
        }catch{
            
        }
        
        return Int16(idMax)
    }
    
    class func getUserByEmail(context: NSManagedObjectContext, email: String) -> UserBean {
        var user = UserBean()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        fetchRequest.predicate = NSPredicate(format: "email == %@", email.lowercased())
        
        do {
            let obj = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if obj.count > 0 {
                user = UserBean.serializer(object: obj.first as AnyObject)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return user
    }
    
    //
    
    class func serializer(object: AnyObject) -> UserBean {
        let userBean = UserBean()
        
        userBean.id = object.value(forKey: "id") as! Int16
        userBean.user_id = object.value(forKey: "user_id") as! Int16
        userBean.name = object.value(forKey: "name") as? String
        userBean.email = (object.value(forKey: "email") as? String)!
        
        return userBean
    }
    //
    
    //Validations
    func validateCreateUser(userEmail: String, userName: String, userPassword: String, userConfirmationPassword: String) -> String{
        var message = ""
        
        if (userName.isEmpty){
            message = "Name can not be empty."
        }
        
        if (message.isEmpty) {
            message = self.validateLoginUser(userEmail: userEmail, userPassword: userPassword)
            
            if (message.isEmpty){
                message = validateConfirmationPassword(userPassword: userPassword, userConfirmationPassword: userConfirmationPassword)
            }
        }
        
        return message
    }
    
    func validateLoginUser(userEmail: String, userPassword: String) -> String {
        var message = ""
        
        message = validateResetPassword(userEmail: userEmail)
        
        if (message.isEmpty) {
            message = validatePassword(userPassword: userPassword)
        }
        
        return message
    }
    
    func validateResetPassword(userEmail: String) -> String {
        var message = ""
        
        if (userEmail.isEmpty){
            message = "Email can not be empty."
        }
        
        return message
    }
    
    func validateUpdatePassword(userPassword: String, userConfirmationPassword: String) -> String {
        var message = ""
        
        message = validatePassword(userPassword: userPassword)
        
        if message.isEmpty {
            message = validateConfirmationPassword(userPassword: userPassword, userConfirmationPassword: userConfirmationPassword)
        }
        
        return message
    }
    
    func validatePassword (userPassword: String) -> String {
        var message = ""
        
        if (userPassword.isEmpty){
            message = "Password can not be empty."
        }else if !(userPassword.characters.count >= deviseMinPassword){
            message = String.init(format: "Password can not be less than %i characters.", deviseMinPassword)
        }
        
        return message;
    }
    
    func validateConfirmationPassword(userPassword: String, userConfirmationPassword: String) -> String {
        var message = ""
        
        if (userConfirmationPassword.isEmpty){
            message = "Confirmation Password can not be empty."
        }else if !(userConfirmationPassword.characters.count >= deviseMinPassword){
            message = String.init(format: "Confirmation Password can not be less than %i characters.", deviseMinPassword)
        }else if (userPassword != userConfirmationPassword){
            message = "can not be different from password"
        }
        
        return message
    }
}
