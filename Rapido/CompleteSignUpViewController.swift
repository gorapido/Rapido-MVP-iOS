//
//  CompleteSignUpViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 7/6/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

protocol CompleteSignUpViewControllerDelegate {
  func finishedPresentation()
}

class CompleteSignUpViewController: XLFormViewController {
  
  var user: PFUser?
  var delegate: CompleteSignUpViewControllerDelegate?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Complete Sign Up")
    
    /*let avatarSection = XLFormSectionDescriptor()
    
    form.addFormSection(avatarSection)
    
    let avatar = XLFormRowDescriptor(tag: "avatar", rowType: XLFormRowDescriptorTypeButton, title: "Avatar")
    
    avatarSection.addFormRow(avatar)*/
    
    let personalSection = XLFormSectionDescriptor()
    
    personalSection.title = "Contact Information"
    
    form.addFormSection(personalSection)
    
    let firstName = XLFormRowDescriptor(tag: "firstName", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    firstName.cellConfigAtConfigure["textField.placeholder"] = "first name"
    firstName.required = true
    
    let lastName = XLFormRowDescriptor(tag: "lastName", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    lastName.cellConfigAtConfigure["textField.placeholder"] = "last name"
    lastName.required = true
    
    let phone = XLFormRowDescriptor(tag: "phone", rowType: XLFormRowDescriptorTypePhone, title: nil)
    
    phone.cellConfigAtConfigure["textField.placeholder"] = "phone"
    phone.addValidator(XLFormRegexValidator(msg: "Must be a valid phone number!", regex: "\\+?1?\\s*\\(?-*\\.*(\\d{3})\\)?\\.*-*\\s*(\\d{3})\\.*-*\\s*(\\d{4})$"))
    phone.required = true
    
    personalSection.addFormRow(firstName)
    personalSection.addFormRow(lastName)
    personalSection.addFormRow(phone)
    
    let addressSection = XLFormSectionDescriptor()
    
    addressSection.title = "Current Address"
    
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
    
    let submitSection = XLFormSectionDescriptor()
    
    form.addFormSection(submitSection)
    
    let submit = XLFormRowDescriptor(tag: "submit", rowType: XLFormRowDescriptorTypeButton, title: "Finish Sign Up")
    
    submit.action.formSelector = "didTouchSubmit:"
    
    submitSection.addFormRow(submit)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    user = PFUser.currentUser()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func didTouchSubmit(sender: XLFormRowDescriptor) {
    tableView.deselectRowAtIndexPath(form.indexPathOfFormRow(sender)!, animated: true)
    
    if formValidationErrors().count == 0 {
      user!.setObject(getFormValue("firstName"), forKey: "firstName")
      user!.setObject(getFormValue("lastName"), forKey: "lastName")
      user!.setObject(getFormValue("phone"), forKey: "phone")
      
      user!.setObject(getFormValue("street"), forKey: "street")
      user!.setObject(getFormValue("city"), forKey: "city")
      user!.setObject(getFormValue("state"), forKey: "state")
      user!.setObject(getFormValue("postalCode"), forKey: "postalCode")
      
      user!.saveInBackgroundWithBlock({ (finished: Bool, error: NSError?) -> Void in
        if error === nil {
          let alert = UIAlertController(title: "Hooray!", message: "You have successfully signed up for Rapido. You can start requesting service right away.", preferredStyle: UIAlertControllerStyle.Alert)
          
          alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
            self.delegate?.finishedPresentation()
          }))
          
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
      let alert = UIAlertController(title: "Error!", message: "It looks like you left something blank. Make sure everything is filled in.", preferredStyle: UIAlertControllerStyle.Alert)
      
      alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
      
      presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  func getFormValue(key: String) -> String! {
    return formValues()![key] as? String
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
