//
//  ChangePasswordViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class ChangePasswordViewController: XLFormViewController {
  
  var user:PFUser?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor()
    
    let passwordSection = XLFormSectionDescriptor()
    
    form.addFormSection(passwordSection)
    
    let password = XLFormRowDescriptor(tag: "password", rowType: XLFormRowDescriptorTypePassword, title: nil)
    
    password.cellConfigAtConfigure["textField.placeholder"] = "password"
    password.required = true
    
    let confirmPassword = XLFormRowDescriptor(tag: "confirmPassword", rowType: XLFormRowDescriptorTypePassword, title: nil)
    
    confirmPassword.cellConfigAtConfigure["textField.placeholder"] = "confirm password"
    
    confirmPassword.required = true
    
    passwordSection.addFormRow(password)
    passwordSection.addFormRow(confirmPassword)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "validateForm:")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  }
  
  func validateForm(sender: UIBarButtonItem) {
    if formValidationErrors().count == 0 {
      let password = formValues()!["password"] as! String
      let confirmPassword = formValues()!["confirmPassword"] as! String
      
      if password == confirmPassword {
        user?.password = password
        
        user?.saveInBackgroundWithBlock({ (finished: Bool, error: NSError?) -> Void in
          self.navigationController?.popToRootViewControllerAnimated(true)
        })
      }
    }
    else {
      let alert = UIAlertController(title: "Error!", message: "It looks like you left something blank. Make sure everything is filled in.", preferredStyle: UIAlertControllerStyle.Alert)
      
      alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
      
      presentViewController(alert, animated: true, completion: nil)
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
