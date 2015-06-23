//
//  LogInViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/16/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class LogInViewController: PFLogInViewController, PFSignUpViewControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    logInView?.logo = nil
    signUpController?.emailAsUsername = true
    signUpController?.signUpView?.logo = nil
    signUpController?.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
    (delegate as! GRLogInViewControllerDelegate).finishedLoggingIn()
    dismissViewControllerAnimated(true, completion: nil)
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
