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
    var password_confirmation: NSString?
    var email: NSString?
    var name: NSString?
    var password: NSString?
    var token: NSString?
    var deviseMinPassword = 6
    
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
