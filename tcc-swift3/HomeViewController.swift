//
//  FirstViewController.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 05/02/17.
//  Copyright © 2017 DO. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var delegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.connection?.viewController = self
        
        if (delegate.loggedUser == nil) {
            self .dismiss(animated: true, completion: nil)
        }else{
            print(delegate.loggedUser.name! as String, delegate.loggedUser.email! as String, delegate.loggedUser.token! as String)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
