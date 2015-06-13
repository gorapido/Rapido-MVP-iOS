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
  @IBOutlet weak var phoneTextField: UITextField!
  
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
    phoneTextField.delegate = self
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
    
    var invalid = false
    
    if (firstNameTextField.text.isEmpty) {
      shakeUp(firstNameTextField)
      invalid = true
    }
    
    if (lastNameTextField.text.isEmpty) {
      shakeUp(lastNameTextField)
      invalid = true
    }
    
    if (emailTextField.text.isEmpty) {
      shakeUp(emailTextField)
      invalid = true
    }
    
    if (phoneTextField.text.isEmpty) {
      shakeUp(phoneTextField)
      invalid = true
    }
    
    if (passwordTextField.text.isEmpty) {
      shakeUp(passwordTextField)
      invalid = true
    }
    
    if (!invalid) {
      user.username = emailTextField.text
      user["phone"] = phoneTextField.text
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
  
  @IBAction func facebookTouchUpInside(sender: AnyObject) {
    PFFacebookUtils.logInInBackgroundWithReadPermissions(["email"], block: { (user: PFUser?, error: NSError?) -> Void in
      if let user = user {
        let profileRequest = FBSDKGraphRequest(graphPath: "me/?fields=first_name,last_name,email,picture", parameters: nil)
        
        profileRequest.startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
          
          user["email"] = result["email"]
          user["firstName"] = result["first_name"]
          user["lastName"] = result["last_name"]
          
          let imageURL = result.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as! String
          
          let url = NSURL(string: imageURL)
          
          if let data = NSData(contentsOfURL: url!) {
            let avatar = PFFile(data: data)
            
            avatar.saveInBackgroundWithBlock({ (finished: Bool, error: NSError?) -> Void in
              if finished {
                user["avatar"] = avatar
                
                user.saveInBackground()
              }
            })
          }
          
          user.saveInBackgroundWithBlock({ (finished: Bool, error: NSError?) -> Void in
            if finished {
              self.delegate?.signInSuccessfully()
            }
            else {
              println(error)
            }
          })
        })
      }
    })
  }
  
  func shakeUp(texField: UITextField) {
    let animation = CAKeyframeAnimation()
    
    animation.keyPath = "position.x"
    animation.values =  [0, 20, -20, 10, 0]
    animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
    animation.duration = 0.3
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    animation.additive = true
    texField.layer.addAnimation(animation, forKey: "shake")
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
