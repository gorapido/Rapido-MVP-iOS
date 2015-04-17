//
//  ProfileViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import Parse

protocol SessionNVCDelegate {
    func signedInSuccessfully()
}

class ProfileTableViewController: UITableViewController, SessionNVCDelegate {
    
    var sessionNVC: UINavigationController?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        //PFUser.logOut()
        
        if var user = PFUser.currentUser() {
            var firstName = user["firstName"] as! String
            var lastName = user["lastName"] as! String
            var email = user["email"] as! String
            
            nameLabel.text = "\(firstName) \(lastName)"
            emailLabel.text = email
        }
        else {
            goToSessionNVC()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signedInSuccessfully() {
        sessionNVC?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 && indexPath.row == 0 {
            PFUser.logOut()
            
            goToSessionNVC()
        }
        else if indexPath.section == 1 {
            if (indexPath.row == 2) {
                var alert = UIAlertController(title: "Sign In to Rapido", message: "Enter your Rapido password to continue.", preferredStyle: .Alert)
                
                alert.addTextFieldWithConfigurationHandler({ passwd in
                    passwd.secureTextEntry = true
                    passwd.placeholder = "password"
                    })
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
                    let passwd = alert.textFields![0] as! UITextField;
                    var user = PFUser.currentUser()!
                    
                    PFUser.logInWithUsernameInBackground(user.email!, password: passwd.text) { (user: PFUser?, err: NSError?) -> Void in
                        if user != nil {
                            self.performSegueWithIdentifier("passwordTCVSegue", sender: nil)
                        }
                    }
                    })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
                    
                    })
                
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func goToSessionNVC() {
        sessionNVC = storyboard?.instantiateViewControllerWithIdentifier("sessionNVC") as? UINavigationController
        
        var signInVC = sessionNVC?.viewControllers.first as! SignInViewController
        
        signInVC.delegate = self
        
        presentViewController(sessionNVC!, animated: true, completion: nil)
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
