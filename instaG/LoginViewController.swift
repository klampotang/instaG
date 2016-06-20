//
//  LoginViewController.swift
//  instaG
//
//  Created by Kelly Lampotang on 6/20/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func onSignIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!)
        { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print("User login failed.")
                print(error.localizedDescription)
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
        
        
    }
    @IBAction func onSignUp(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
     
        newUser.signUpInBackgroundWithBlock{(success: Bool, error:NSError?) -> Void in
        if success {
            print("Yay, created a new user")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            
        } else {
            print(error?.localizedDescription)
            
        }
            
      }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override
    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
