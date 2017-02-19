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
    
    func validateCreateUser(userEmail: String, userName: String, userPassword: String, userConfirmationPassword: String) -> String{
        var message = ""
        
        if (userName.isEmpty){
            message = "Name can not be empty."
        }
        
        if (message.isEmpty) {
            message = self.validateLoginUser(userEmail: userEmail, userPassword: userPassword)
            
            if (message.isEmpty){
                if (userConfirmationPassword.isEmpty){
                    message = "Confirmation Password can not be empty."
                }else if !(userConfirmationPassword.characters.count > 7){
                    message = "Confirmation Password can not be less than 8 characters."
                }else if (userPassword != userConfirmationPassword){
                    message = "Confirmation Password can not be less than 8 characters."
                }
            }
        }
        
        return message
    }
    
    func validateLoginUser(userEmail: String, userPassword: String) -> String {
        var message = ""
        
        message = validateResetPassword(userEmail: userEmail)
        
        if (message.isEmpty) {
            if (userPassword.isEmpty){
                message = "Password can not be empty."
            }else if !(userPassword.characters.count > 7){
                message = "Password can not be less than 8 characters."
            }
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
}
