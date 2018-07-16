//
//  LoginViewController.swift
//  GistDemo
//
//  Created by Apple on 16/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.borderColor = UIColor.black.cgColor
        self.loginButton.layer.borderWidth = 1.0
    }
    
    @IBAction func loginClicked(_ sender: Any) {
    }

}
