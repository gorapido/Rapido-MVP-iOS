//
//  SignInViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwd: UITextField!
    
    var delegate: SessionNVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwd.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInTapped(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(email.text, password: passwd.text) { (user: PFUser?, err: NSError?) -> Void in
            if user != nil {
                self.delegate?.signedInSuccessfully()
            } else {
                
            }
        }
    }

    @IBAction func signUpTouchUpInside(sender: AnyObject) {
        performSegueWithIdentifier("signUpVCSegue", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var signUpVC = segue.destinationViewController as? SignUpViewController
        
        signUpVC?.delegate = delegate
    }
    

}
