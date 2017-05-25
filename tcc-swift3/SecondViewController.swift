//
//  SecondViewController.swift
//  tcc-swift3
//
//  Created by Diego Oliveira on 05/02/17.
//  Copyright © 2017 DO. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var delegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = UIApplication.shared.delegate as! AppDelegate
        /*
        delegate.connection?.viewController = self
        delegate.connection?.logoutUser()
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
