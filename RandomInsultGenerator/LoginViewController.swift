//
//  LoginViewController.swift
//  RandomInsultGenerator
//
//  Created by Melissa Allgeier on 3/24/16.
//  Copyright © 2016 Melissa Allgeier. All rights reserved.
//

import UIKit
import Foundation
import TwitterKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set light status bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent



        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
        let alert = UIAlertController(title: "Logged In",
            message: "User \(unwrappedSession.userName) has logged in",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
            } else {
        NSLog("Login error: %@", error!.localizedDescription);
            }
        }

// TODO: Change where the log in button is positioned in your view
logInButton.center = self.view.center
self.view.addSubview(logInButton)

    }
}
