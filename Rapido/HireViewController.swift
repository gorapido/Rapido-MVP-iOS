//
//  HireViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/18/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MobileCoreServices

class HireViewController: XLFormViewController, PFLogInViewControllerDelegate {
  
  var user: PFUser?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Hire")
    
    let personalSection = XLFormSectionDescriptor()
    
    form.addFormSection(personalSection)
    
    let firstName = XLFormRowDescriptor(tag: "firstName", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    firstName.cellConfigAtConfigure["textField.placeholder"] = "first name"
    
    firstName.required = true
    
    let lastName = XLFormRowDescriptor(tag: "lastName", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    lastName.cellConfigAtConfigure["textField.placeholder"] = "last name"
    
    lastName.required = true
    
    let email = XLFormRowDescriptor(tag: "email", rowType: XLFormRowDescriptorTypeEmail, title: nil)
    
    email.cellConfigAtConfigure["textField.placeholder"] = "email"
    
    email.required = true
    
    email.addValidator(XLFormValidator.emailValidator())
    
    let phone = XLFormRowDescriptor(tag: "phone", rowType: XLFormRowDescriptorTypePhone, title: nil)
    
    phone.cellConfigAtConfigure["textField.placeholder"] = "phone"
    
    phone.required = true
    
    personalSection.addFormRow(firstName)
    personalSection.addFormRow(lastName)
    personalSection.addFormRow(email)
    personalSection.addFormRow(phone)
    
    let addressSection = XLFormSectionDescriptor()
    
    form.addFormSection(addressSection)
    
    let street = XLFormRowDescriptor(tag: "street", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    street.cellConfigAtConfigure["textField.placeholder"] = "Street"
    street.required = true
    
    let city = XLFormRowDescriptor(tag: "city", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    city.cellConfigAtConfigure["textField.placeholder"] = "City"
    city.required = true
    
    let state = XLFormRowDescriptor(tag: "state", rowType: XLFormRowDescriptorTypeText, title: "State")
    
    state.cellConfigAtConfigure["textField.placeholder"] = "State"
    //state.required = true
    state.disabled = true
    state.value = "FL"
    
    let postalCode = XLFormRowDescriptor(tag: "postalCode", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    postalCode.cellConfigAtConfigure["textField.placeholder"] = "Postal Code"
    postalCode.required = true
    
    addressSection.addFormRow(street)
    addressSection.addFormRow(city)
    addressSection.addFormRow(state)
    addressSection.addFormRow(postalCode)
    
    let detailsSection = XLFormSectionDescriptor()
    
    form.addFormSection(detailsSection)
    
    let category = XLFormRowDescriptor(tag: "category", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Category")
    
    category.selectorOptions = [
      // XLFormOptionsObject(value: "Plumbing", displayText: "Plumbing"),
      // XLFormOptionsObject(value: "Electrical", displayText: "Electrical"),
      XLFormOptionsObject(value: "Air & Heating", displayText: "Air & Heating"),
      XLFormOptionsObject(value: "Massage", displayText: "Massage"),
      XLFormOptionsObject(value: "Computer Repair", displayText: "Computer Repair"),
      XLFormOptionsObject(value: "Web Development", displayText: "Web Development"),
      XLFormOptionsObject(value: "Mobile App Development", displayText: "Mobile App Development"),
      // XLFormOptionsObject(value: "Other", displayText: "Other")
    ]
    
    category.required = true
    
    // let other = XLFormRowDescriptor(tag: "other", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    // other.cellConfigAtConfigure["textView.placeholder"] = "Other Category"
    // other.hidden = "$category===0"
    
    let start = XLFormRowDescriptor(tag: "start", rowType: XLFormRowDescriptorTypeDateTime, title: "Preferred Time")
    
    start.required = true
    
    let problem = XLFormRowDescriptor(tag: "problem", rowType: XLFormRowDescriptorTypeTextView, title: nil)
    
    problem.cellConfigAtConfigure["textView.placeholder"] = "What's the problem?"
    problem.required = true
    
    detailsSection.addFormRow(category)
    detailsSection.addFormRow(start)
    detailsSection.addFormRow(problem)
    
    let submitSection = XLFormSectionDescriptor()
    
    form.addFormSection(submitSection)
    
    let submit = XLFormRowDescriptor(tag: "submit", rowType: XLFormRowDescriptorTypeButton, title: "Submit")
    
    submit.action.formSelector = "didTouchSubmit:"
    
    submitSection.addFormRow(submit)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    user = PFUser.currentUser()
    
    // Do any additional setup after loading the view.
    if (user != nil) {
      form.formRowWithTag("firstName").value = user?["firstName"]
      form.formRowWithTag("lastName").value = user?["lastName"]
      form.formRowWithTag("email").value = user?["email"]
      form.formRowWithTag("phone").value = user?["phone"]
      
      form.formRowWithTag("street").value = user?["street"]
      form.formRowWithTag("city").value = user?["city"]
      form.formRowWithTag("postalCode").value = user?["postalCode"]
    }
    else {
      let logInController = LogInViewController()
      
      logInController.delegate = self
      logInController.fields = (PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.Facebook)
      
      presentViewController(logInController, animated: false, completion: nil)
    }
    
    let lightGray = UIColor(red: 0xCC, green: 0xCC, blue: 0xCC, alpha: 1)
    
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: lightGray], forState: .Normal)
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
    
    for item in tabBarController!.tabBar.items as! [UITabBarItem] {
      if let image = item.image {
        item.image = image.imageWithRenderingMode(.AlwaysOriginal)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func didTouchSubmit(sender: XLFormRowDescriptor) {
    tableView.deselectRowAtIndexPath(form.indexPathOfFormRow(sender), animated: true)
    
    if formValidationErrors().count == 0 {
      user!["lastName"] = getFormValue("firstName")
      user!["lastName"] = getFormValue("lastName")
      user!["email"] = getFormValue("email")
      user!["phone"] = getFormValue("phone")
      
      user!["street"] = getFormValue("street")
      user!["city"] = getFormValue("city")
      user!["state"] = "FL"
      user!["postalCode"] = getFormValue("postalCode")
      
      user?.saveInBackground()
      
      let job = PFObject(className: "Job")
      
      job["consumer"] = self.user!
      job["start"] = formValues()!["start"] as! NSDate
      job["category"] = formValues()!["category"]!.valueData()
      job["problem"] = getFormValue("problem")
      
      job.saveInBackgroundWithBlock({ (finished: Bool, error: NSError?) -> Void in
        if error === nil {
          let alert = UIAlertController(title: "Sent!", message: "Your work request has been sent. Someone will in touch, shortly.", preferredStyle: UIAlertControllerStyle.Alert)
          
          alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
          
          self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
          let alert = UIAlertController(title: "Darn!", message: "Something went wrong. Please try submitting again.", preferredStyle: UIAlertControllerStyle.Alert)
          
          alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
          
          self.presentViewController(alert, animated: true, completion: nil)
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
  
  func getFormValue(key: String) -> String! {
    return formValues()![key] as? String
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
