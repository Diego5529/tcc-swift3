//
//  ViewController.swift
//  tcc-swift
//
//  Created by Diego on 8/7/16.
//  Copyright © 2016 ifsp. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics
import Former

class ViewController: UIViewController  {
    
    //static vars
    static var ksignIn = "signIn"
    static var ksignUp = "signUp"
    static var kresetPassword = "resetPassword"
    static var kupdatePassword = "updatePassword"
    var currentStatus = ksignIn
    
    //views
    //@IBOutlet var activityView: UIView!
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //signInView
    @IBOutlet var signInView: UIView!
    @IBOutlet weak var signInEmailTextField: UITextField!
    @IBOutlet weak var signInPasswordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var goToSignUpButton: UIButton!
    @IBOutlet var goToResetPasswordButton: UIButton!
    
    //signUpView
    @IBOutlet var signUpView: UIView!
    @IBOutlet weak var signUpNameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPassTextField: UITextField!
    @IBOutlet weak var signUpPassConfirmationTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var cancelSignUpButton: UIButton!
    
    //resetPasswordView
    @IBOutlet var resetPasswordView: UIView!
    @IBOutlet weak var resetPasswordEmailTextField: UITextField!
    @IBOutlet var resetPasswordButton: UIButton!
    @IBOutlet var cancelResetPasswordButton: UIButton!
    
    var delegate: AppDelegate!
    var urlPath: NSString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init defaults vars
        delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.connection?.viewController = self
        
        //prepareViews
        hiddenAllViews()
        showSignInView()
        
        //Init Reachability
        delegate.setupReachability(nil, useClosures: true)
        delegate.startNotifier()
        
        urlPath = "http://localhost:3000/api"
        
        signInEmailTextField.text = "diego.6.souza@gmail.com"
        signInPasswordTextField.text = "12345678"
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //try login by token on defaults users
        delegate.connection?.loginByToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //signInView
    @IBAction func signIn(_ sender: UIButton) {
        print("SignIn")
        
        delegate.genericUser?.email = signInEmailTextField.text as String?
        delegate.genericUser?.password = signInPasswordTextField.text as String?
        
        let message = UserBean().validateLoginUser(userEmail: (delegate.genericUser?.email!)! as String, userPassword: ((delegate.genericUser?.password)!) as String)
        
        if (message.isEmpty){
            delegate.connection?.viewController = self
            delegate.connection? .signIn()
        }else{
            self.showMessage(message: message, title: "", cancel: "")
        }
    }
    
    @IBAction func goToSignUp(_ sender: UIButton){
        showSignUpView()
    }
    
    @IBAction func goToResetPassword(_ sender: UIButton){
        showResetPasswordView()
    }
    
    //signUpView
    @IBAction func signUp(_ sender: UIButton) {
        print("SignUp")
        
        delegate.genericUser?.name = signUpNameTextField.text as String?
        delegate.genericUser?.email = signUpEmailTextField.text as String?
        delegate.genericUser?.password = signUpPassTextField.text as String?
        delegate.genericUser?.password_confirmation = signUpPassConfirmationTextField.text as String?
        
        if currentStatus == ViewController.ksignUp {
            let message = UserBean().validateCreateUser(userEmail: (delegate.genericUser?.email)! as String, userName: (delegate.genericUser?.name)! as String, userPassword: (delegate.genericUser?.password)!, userConfirmationPassword: (delegate.genericUser?.password_confirmation)!)
            
            if (message.isEmpty){
                delegate.connection?.viewController = self
                
                delegate.connection?.signUp()
            }else{
                self.showMessage(message: message, title: "", cancel: "")
            }
        }else{
            let message = UserBean().validateUpdatePassword(userPassword: (delegate.genericUser?.password)! as String, userConfirmationPassword: (delegate.genericUser?.password_confirmation!)!)
            
            if (message.isEmpty){
                delegate.connection?.viewController = self
                
                delegate.connection?.updatePassword()
            }else{
                self.showMessage(message: message, title: "", cancel: "")
            }
        }
    }
    
    @IBAction func cancelSignUp(_ sender: UIButton) {
        showSignInView()
    }
    
    //resetPasswordView
    @IBAction func resetPassword(_ sender: UIButton) {
        print("Reset Password")
        
        delegate.genericUser?.email = resetPasswordEmailTextField.text
        
        let message = UserBean().validateResetPassword(userEmail: (delegate.genericUser?.email)!)
        
        if (message.isEmpty){
            delegate.connection?.viewController = self
            
            delegate.connection?.resetPassword()
        }else{
            self.showMessage(message: message, title: "", cancel: "")
        }
    }
    
    @IBAction func cancelResetPassword(_ sender: UIButton) {
        showSignInView()
    }
    
    //manipulateViews
    func hiddenAllViews() {
        //hidden ActivityViews
        //activityView.isHidden = true
        //activityIndicator.isHidden = true
  
        //signInView
        signInView.isHidden = true
        signInEmailTextField.text = ""
        signInPasswordTextField.text = ""
        
        //signUpView
        signUpView.isHidden = true
        signUpNameTextField.text = ""
        signUpEmailTextField.text = ""
        signUpPassTextField.text = ""
        signUpPassConfirmationTextField.text = ""
        signUpButton.titleLabel?.text = currentStatus == ViewController.kupdatePassword ? "Update" : "Sign up"
        
        //resetPasswordView
        resetPasswordView.isHidden = true
        //resetPasswordEmailTextField.text = ""
    }
    
    func showSignInView() {
        currentStatus = ViewController.ksignIn
        hiddenAllViews()
        
        signInView.isHidden = false
        
        if ((delegate.genericUser?.email) != nil) {
            signInEmailTextField.text = delegate.genericUser?.email as String?
        }
    }
    
    func showSignUpView() {
        currentStatus = ViewController.ksignUp
        hiddenAllViews()
        
        signUpView.isHidden = false
    }
    
    func showResetPasswordView() {
        currentStatus = ViewController.kresetPassword
        hiddenAllViews()
        
        resetPasswordView.isHidden = false
    }
    
    func showUpdatePasswordView() {
        hiddenAllViews()
        currentStatus = ViewController.kupdatePassword
        
        signUpView.isHidden = false
        signUpNameTextField.isHidden = true
        signUpEmailTextField.isHidden = true
        signUpButton.titleLabel?.text = "Update"
    }
    
    //AlertView
    func showMessage(message: String, title: String, cancel: String){
        let alertController = UIAlertController(title: title.isEmpty ? "Error" : title, message: message.isEmpty ? "" : message, preferredStyle: UIAlertControllerStyle.alert)
        
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
        OperationQueue.main.addOperation {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
