//
//  EditAddressViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/22/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class EditAddressViewController: XLFormViewController {
  
  var user: PFObject?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor()
    
    let addressSection = XLFormSectionDescriptor()
    
    form.addFormSection(addressSection)
    
    let street = XLFormRowDescriptor(tag: "street", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    street.cellConfigAtConfigure["textField.placeholder"] = "Street"
    
    street.required = true
    
    let city = XLFormRowDescriptor(tag: "city", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    city.cellConfigAtConfigure["textField.placeholder"] = "City"
    
    city.required = true
    
    let state = XLFormRowDescriptor(tag: "state", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    state.cellConfigAtConfigure["textField.placeholder"] = "State"
    
    state.required = true
    // state.disabled = true
    state.value = "FL"
    
    let postalCode = XLFormRowDescriptor(tag: "postalCode", rowType: XLFormRowDescriptorTypeText, title: nil)
    
    postalCode.cellConfigAtConfigure["textField.placeholder"] = "Postal Code"
    
    postalCode.required = true
    
    addressSection.addFormRow(street)
    addressSection.addFormRow(city)
    addressSection.addFormRow(state)
    addressSection.addFormRow(postalCode)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "validateForm:")
    
    form.formRowWithTag("street")!.value = user!.objectForKey("street")
    form.formRowWithTag("city")!.value = user!.objectForKey("city")
    form.formRowWithTag("state")!.value = user!.objectForKey("state")
    form.formRowWithTag("postalCode")!.value = user!.objectForKey("postalCode")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func validateForm(button: UIBarButtonItem) {
    if formValidationErrors().count == 0 {
      user!.setObject(formValues()!["street"]!, forKey: "street")
      user!.setObject(formValues()!["city"]!, forKey: "city")
      user!.setObject(formValues()!["state"]!, forKey: "state")
      user!.setObject(formValues()!["postalCode"]!, forKey: "postalCode")
      
      user?.saveInBackgroundWithBlock({ (finished: Bool, error: NSError?) -> Void in
        if (finished) {
          self.navigationController?.popToRootViewControllerAnimated(true)
        }
      })
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
