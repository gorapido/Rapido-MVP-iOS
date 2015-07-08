//
//  SignUpViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 7/6/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class SignUpViewController: PFSignUpViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    emailAsUsername = true
    
    let logo = UIImage(named: "Rapido")
    
    let imageView = UIImageView(image: logo)
    
    imageView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    imageView.contentMode = .ScaleAspectFit
    
    signUpView?.logo = imageView
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
