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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        //PFUser.logOut()
        
        var user = PFUser.currentUser()
        
        if user == nil {
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
