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
    /*
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print(result)
        fetchProfile()
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large), id"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError)
                return
            }
            
            let email = user["email"] as? String
            let provider = "facebook"
            let id = user["id"] as? String
            let name = user["first_name"] as? String
            
            print(email, user)
            
            var pictureUrl = ""
            
            if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                pictureUrl = url
            }
            
            print("Auth")
            
            let stringURL = self.urlPath .stringByAppendingString("/user/omniauth")
            
            let url = NSURL(string: stringURL)!
            
            let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
            
            request.HTTPMethod = "POST"
            
            //email, :provider, :uid, :name
            let bodyData = String(format: "user[email]=%@&user[provider]=%@&user[uid]=%@&user[name]=%@", email!, provider, id!, name!)
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if (error != nil){
                    print(error)
                }else{
                    do{
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        if (jsonResult is NSArray){
                            print(jsonResult)
                        }
                        else if(jsonResult is NSDictionary){
                            print(jsonResult)
                            
                            let userClass: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: self.context)
                            
                            for (key, value) in jsonResult as! NSDictionary {
                                print("Property: \"\(key as! String)\" Value: \"\(value as! String)\" ")
                                
                                userClass.setValue(value, forKey:key as! String);
                            }
                            
                            print (userClass)
                            
                            do {
                                try self.context.save()
                                self.defaults.setObject(userClass, forKey: "loggedUser")
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
                        
                        let select = NSFetchRequest(entityName: "User")
                        
                        select.returnsObjectsAsFaults = false
                        
                        do {
                            let results = try self.context.executeFetchRequest(select)
                            
                            if results.count > 0 {
                                print(results.count)
                            }
                        }catch{
                        }
                    }
                }
            }
            
            task.resume()
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    */
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.addSubview(loginButton)
        //loginButton.center = view.center
        //loginButton.delegate = self
        
        //prepareViewa
        hiddenAllViews()
        showSignInView()
        
        //init defaults vars
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        defaults = UserDefaults.standard
        
        context = delegate.managedObjectContext
        
        urlPath = "http://localhost:3000/api"
        
        signInEmailTextField.text = "diego.6.souza@gmail.com"
        signInPasswordTextField.text = "12345678"
        
        //loading settings
        _ = self.defaults.string(forKey: "loggedUser")
        
        //if let _ = FBSDKAccessToken.currentAccessToken() {
        //    fetchProfile()
        //}
        
        /*
        let select = NSFetchRequest()
        
        select.predicate = NSPredicate(format: "token == %@", obj!)
        
        select.returnsObjectsAsFaults = false
        
        do {
            let results = try self.context.executeFetchRequest(select)
            
            if results.count > 0 {
                print(results.count)
            }
        }catch{
            print(loggedUser.name)
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //signInView
    @IBAction func signIn(_ sender: UIButton) {
        print("SignIn")
        
        let connection = Connection()
        
        connection.genericUser?.e_mail = signInEmailTextField.text as NSString?
        connection.genericUser?.password = signInPasswordTextField.text as NSString?
        
        connection .signIn()
        /*&
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerScene1") as UIViewController
        self.present(vc, animated: true, completion: nil)
        */
        let stringURL = urlPath .appending("/user/sign_in")
        
        let url = URL(string: stringURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        //request.httpBody = jsonData
        
        var userClass = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        
        userClass.email = signInEmailTextField.text
        let password = signInPasswordTextField.text
        
        let bodyData = String(format: "user[email]=%@&user[password]=%@", userClass.email!, password!)
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
                        
                        let user: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.context)
                        
                        for (key, value) in jsonResult as! NSDictionary {
                                print("Property: \"\(key as! String)\" Value: \"\(value as! String)\" ")
                            
                            user.setValue(value, forKey:key as! String);
                        }
                        
                        userClass = user as! User
                        
                        print (userClass.token as Any)
                        
                        
                        do {
                            try self.context.save()
                            self.defaults.set(userClass.token, forKey: "loggedUser")
                            
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarControllerScene1") as UIViewController
                            self.present(vc, animated: true, completion: nil)
                            
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
    
    @IBAction func goToSignUp(_ sender: UIButton){
        showSignUpView()
    }
    
    @IBAction func goToResetPassword(_ sender: UIButton){
        showResetPasswordView()
    }
    
    //signUpView
    @IBAction func signUp(_ sender: UIButton) {
        print("SignUp")
        
        let stringURL = urlPath .appending("/user/sign_up")
        
        let url = URL(string: stringURL as String)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let userClass = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        
        userClass.name = signUpNameTextField.text
        userClass.email = signUpEmailTextField.text
        let password = signUpPassTextField.text
        let passwordConfirmation = signUpPassConfirmationTextField.text
        
        let bodyData = String(format: "user[name]=%@&user[email]=%@&user[password]=%@&user[password_confirmation]=%@", userClass.name!, userClass.email!, password!, passwordConfirmation!)
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
                            
                            do { try self.context.save() }catch{}
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
}
