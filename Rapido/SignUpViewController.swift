//
//  SignUpViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/17/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var delegate: SessionNVCDelegate?

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpTouchUpInside(sender: AnyObject) {
        var user = PFUser()
        
        user.username = emailTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        user["firstName"] = firstNameTextField.text as String
        user["lastName"] = lastNameTextField.text as String
        
        user.signUpInBackgroundWithBlock() { (success: Bool, err: NSError?) -> Void in
            if success {
                self.delegate?.signedInSuccessfully()
            }
            else {
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
