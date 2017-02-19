//
//  ViewController.swift
//  tcc-swift
//
//  Created by Diego on 8/7/16.
//  Copyright © 2016 ifsp. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController  {
    
    //views
    @IBOutlet var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    var defaults: UserDefaults!
    var context: NSManagedObjectContext!
    var urlPath: NSString = ""
    var loggedUser: User!
    var person: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prepareViewa
        hiddenAllViews()
        showSignInView()
        
        //init defaults vars
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        //Init Reachability
        delegate.setupReachability(nil, useClosures: true)
        delegate.startNotifier()
        
        defaults = UserDefaults.standard
        
        context = delegate.managedObjectContext
        
        urlPath = "http://localhost:3000/api"
        
        signInEmailTextField.text = "diego.6.souza@gmail.com"
        signInPasswordTextField.text = "12345678"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //loading settings
        let token = self.defaults.string(forKey: "token")
        
        if (token != nil && (token?.characters.count)! > 0) {
            print(token as Any)
            
            //2
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
            
            fetchRequest.predicate = NSPredicate(format: "token == %@", token!)
            
            //3
            do {
                person = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            if (person.count > 0){
                loggedUser = person.first as! User!
                
                print(loggedUser.name as Any)
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerScene1") as UIViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //signInView
    @IBAction func signIn(_ sender: UIButton) {
        print("SignIn")
        
        let connection = Connection()
        
        connection.genericUser?.email = signInEmailTextField.text as NSString?
        connection.genericUser?.password = signInPasswordTextField.text as NSString?
        
        let validateUser = UserBean()
        
        let message = validateUser.validateLoginUser(userEmail: connection.genericUser?.email as! String, userPassword: (connection.genericUser?.password)! as String)
        
        if (message.isEmpty){
            connection.viewController = self
            
            connection .signIn()
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
        
        let connection = Connection()
        
        connection.genericUser?.name = signUpNameTextField.text as NSString?
        connection.genericUser?.email = signUpEmailTextField.text as NSString?
        connection.genericUser?.password = signUpPassTextField.text as NSString?
        connection.genericUser?.password_confirmation = signUpPassConfirmationTextField.text as NSString?
        
        let validateUser = UserBean()
        
        let message = validateUser.validateCreateUser(userEmail: (connection.genericUser?.email)! as String, userName: (connection.genericUser?.name)! as String, userPassword: (connection.genericUser?.password)! as String, userConfirmationPassword: connection.genericUser?.password_confirmation as! String)
        
        if (message.isEmpty){
            connection.viewController = self
            
            connection.signUp()
        }else{
            self.showMessage(message: message, title: "", cancel: "")
        }
    }
    
    @IBAction func cancelSignUp(_ sender: UIButton) {
        showSignInView()
    }
    
    //resetPasswordView
    @IBAction func resetPassword(_ sender: UIButton) {
        showSignInView()
    }
    
    @IBAction func cancelResetPassword(_ sender: UIButton) {
        showSignInView()
    }
    
    //manipulateViews
    func hiddenAllViews() {
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
        
        //resetPasswordView
        resetPasswordView.isHidden = true
        resetPasswordEmailTextField.text = ""
    }
    
    func showSignInView() {
        hiddenAllViews()
        
        signInView.isHidden = false
    }
    
    func showSignUpView() {
        hiddenAllViews()
        
        signUpView.isHidden = false
    }
    
    func showResetPasswordView() {
        hiddenAllViews()
        
        resetPasswordView.isHidden = false
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
        self.present(alertController, animated: true, completion: nil)
    }
}
