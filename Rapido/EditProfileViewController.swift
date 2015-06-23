//
//  ProfileFormViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class EditProfileViewController: XLFormViewController {
  
  var user: PFUser?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Edit Profile")
    
    /*let avatarSection = XLFormSectionDescriptor()
    
    form.addFormSection(avatarSection)
    
    let avatar = XLFormRowDescriptor(tag: "avatar", rowType: XLFormRowDescriptorTypeButton, title: "Avatar")
    
    avatarSection.addFormRow(avatar)*/
    
    let personalSection: XLFormSectionDescriptor = XLFormSectionDescriptor()
    
    form.addFormSection(personalSection)
    
    let firstName = XLFormRowDescriptor(tag: "firstName", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    firstName.cellConfigAtConfigure["textField.placeholder"] = "first name"
    firstName.required = true
    
    let lastName = XLFormRowDescriptor(tag: "lastName", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    lastName.cellConfigAtConfigure["textField.placeholder"] = "last name"
    lastName.required = true
    
    let email = XLFormRowDescriptor(tag: "email", rowType: XLFormRowDescriptorTypeEmail, title: nil)
    
    email.cellConfigAtConfigure["textField.placeholder"] = "email"
    email.addValidator(XLFormValidator.emailValidator())
    email.required = true
    
    let phone = XLFormRowDescriptor(tag: "phone", rowType: XLFormRowDescriptorTypePhone, title: nil)
    
    phone.cellConfigAtConfigure["textField.placeholder"] = "phone"
    phone.addValidator(XLFormRegexValidator(msg: "Must be a valid phone number!", regex: "\\+?1?\\s*\\(?-*\\.*(\\d{3})\\)?\\.*-*\\s*(\\d{3})\\.*-*\\s*(\\d{4})$"))
    phone.required = true
    
    personalSection.addFormRow(firstName)
    personalSection.addFormRow(lastName)
    personalSection.addFormRow(email)
    personalSection.addFormRow(phone)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "validateForm:")
    
    form.formRowWithTag("firstName").value = user!["firstName"]
    form.formRowWithTag("lastName").value = user!["lastName"]
    form.formRowWithTag("email").value = user!["email"]
    form.formRowWithTag("phone").value = user!["phone"]
  }
  
  func validateForm(button: UIBarButtonItem) {
    if formValidationErrors().count == 0 {
      user!["firstName"] = formValues()!["firstName"]
      user!["lastName"] = formValues()!["lastName"]
      user!["email"] = formValues()!["email"]
      user!["phone"] = formValues()!["phone"]
      
      user?.saveInBackgroundWithBlock({ (finished: Bool, error: NSError?) -> Void in
        if (finished) {
          self.navigationController?.popToRootViewControllerAnimated(true)
        }
      })
    }
    else {
      for error in formValidationErrors() {
        let error = error as! NSError
        let status = error.userInfo![XLValidationStatusErrorKey] as! XLFormValidationStatus
      
        if let cell = tableView.cellForRowAtIndexPath(form.indexPathOfFormRow(status.rowDescriptor)) {
          animateCell(cell)
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func animateCell(cell: UITableViewCell) {
    let animation = CAKeyframeAnimation()
    
    animation.keyPath = "position.x"
    animation.values =  [0, 20, -20, 10, 0]
    animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
    animation.duration = 0.3
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    animation.additive = true
    cell.layer.addAnimation(animation, forKey: "shake")
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
