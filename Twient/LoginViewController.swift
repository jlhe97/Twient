//
//  LoginViewController.swift
//  Twient
//
//  Created by Juan Luis Herrero Estrada on 6/27/16.
//  Copyright © 2016 Juan Luis Herrero Estrada. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    @IBAction func onLoginButton(sender: AnyObject) {
        
        let twitterClient = TwitterClient.sharedInstance
        twitterClient.login({ () -> () in
                print("I've logged in")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) -> () in
                print("error: \(error.localizedDescription)")
        }
    } // end of onLoginButton function
    
    // ------------------------------------------------------------------------------------------------------

} // end of LoginViewController class
