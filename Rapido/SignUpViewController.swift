//
//  SignUpViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/17/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var delegate: SessionDelegate?
  var kbHeight: CGFloat?
  var kbDown: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    firstNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
    lastNameTextField.autocapitalizationType = UITextAutocapitalizationType.Words
    
    passwordTextField.secureTextEntry = true
    
    firstNameTextField.delegate = self
    lastNameTextField.delegate = self
    emailTextField.delegate = self
    passwordTextField.delegate = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func signUpTouchUpInside(sender: AnyObject) {
    let user = PFUser()
    
    user.username = emailTextField.text
    user.email = emailTextField.text
    user.password = passwordTextField.text
    user["firstName"] = firstNameTextField.text as String
    user["lastName"] = lastNameTextField.text as String
    
    user.signUpInBackgroundWithBlock() { (success: Bool, err: NSError?) -> Void in
      if success {
        self.delegate?.signInSuccessfully()
      }
      else {
        
      }
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    return false
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        if kbDown {
          kbDown = false
          kbHeight = keyboardSize.height
          
          animateTextField(true)
        }
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    kbDown = true
    
    animateTextField(false)
  }
  
  func animateTextField(up: Bool) {
    let movement = (up ? -kbHeight! : kbHeight)
    
    UIView.animateWithDuration(0.3, animations: {
      self.view.frame = CGRectOffset(self.view.frame, 0, movement!)
    })
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
