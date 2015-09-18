//
//  LogInViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/16/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

protocol LogInViewControllerDelegate: PFLogInViewControllerDelegate {
  func finishedLoggingIn()
}

class LogInViewController: PFLogInViewController, PFSignUpViewControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    facebookPermissions = ["public_profile", "email"]
    
    let logo = UIImage(named: "Rapido")
    
    let imageView = UIImageView(image: logo)

    imageView.contentMode = .ScaleAspectFit
    imageView.clipsToBounds = true
    
    logInView?.logo = imageView
    
    println(logo!.size.height)
    
    signUpController = SignUpViewController()
    signUpController?.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
    (delegate as! LogInViewControllerDelegate).finishedLoggingIn()
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
