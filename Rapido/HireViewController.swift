//
//  HireViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/18/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MobileCoreServices

class HireViewController: XLFormViewController, LogInViewControllerDelegate, CompleteSignUpViewControllerDelegate {
  
  var user: PFUser?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Hire")
    
    let detailsSection = XLFormSectionDescriptor()
    
    form.addFormSection(detailsSection)
    
    let category = XLFormRowDescriptor(tag: "category", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Category")
    
    category.selectorOptions = ["Plumbing", "Electrical", "Air & Heating", "Massage", "Lawn"]
    
    category.required = true
    
    let other = XLFormRowDescriptor(tag: "other", rowType: XLFormRowDescriptorTypeText, title: "What?")
    
    other.required = true
    other.hidden = "NOT $category.value contains 'Other'"
    
    let when = XLFormRowDescriptor(tag: "when", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Start")
    
    when.selectorOptions = ["ANY TIME 8am - 8pm", "MORNING 8am - 12pm", "AFTERNOON 12pm - 4pm", "EVENING 4pm - 8pm"]
    when.required = true
    
    let start = XLFormRowDescriptor(tag: "start", rowType: XLFormRowDescriptorTypeDate, title: "When?")
    
    start.required = true
    // start.hidden = "NOT $when.value contains 'Later'"
    
    let problem = XLFormRowDescriptor(tag: "problem", rowType: XLFormRowDescriptorTypeTextView, title: nil)
    
    problem.cellConfigAtConfigure["textView.placeholder"] = "What's the problem?"
    problem.required = true
    
    detailsSection.addFormRow(category)
    detailsSection.addFormRow(other)
    detailsSection.addFormRow(when)
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
    
    // Do any additional setup after loading the view.
    let lightGray = UIColor(red: 0xCC, green: 0xCC, blue: 0xCC, alpha: 1)
    
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: lightGray], forState: .Normal)
    UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Selected)
    
    for item in tabBarController!.tabBar.items as! [UITabBarItem] {
      if let image = item.image {
        item.image = image.imageWithRenderingMode(.AlwaysOriginal)
      }
    }
    
    common()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    /* if user == nil {
      user = PFUser.currentUser()
    } */
    
    common()
  }
  
  func common() {
    user = PFUser.currentUser()
    
    if (user != nil) {
      if let phone = user?.objectForKey("phone") as? String {
        
      }
      else {
        let completeSignUpViewController = storyboard?.instantiateViewControllerWithIdentifier("CompleteSignUp") as! CompleteSignUpViewController
        
        completeSignUpViewController.delegate = self
        
        presentViewController(completeSignUpViewController, animated: true, completion: nil)
      }
    }
    else {
      let logInController = LogInViewController()
      
      logInController.delegate = self
      logInController.fields = (PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.Facebook)
      
      presentViewController(logInController, animated: false, completion: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func didTouchSubmit(sender: XLFormRowDescriptor) {
    tableView.deselectRowAtIndexPath(form.indexPathOfFormRow(sender)!, animated: true)
    
    if formValidationErrors().count == 0 {
      let job = PFObject(className: "Job")
      
      job.setObject(user!, forKey: "consumer")
      
      let category = formValues()!["category"]!.valueData() as! String
      
      if category == "Other" {
        job.setObject(getFormValue("other"), forKey: "category")
      }
      else {
        job.setObject(category, forKey: "category")
      }
      
      job.setObject(formValues()!["when"]!, forKey: "when")
      
      if let start = formValues()?["start"] as? NSDate {
        job.setObject(start, forKey: "start")
      }
      else {
        job.setObject(NSDate(), forKey: "start")
      }
      
      job.setObject(getFormValue("problem"), forKey: "problem")
      
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
          
          self.form.formRowWithTag("category")!.value = nil
          self.form.formRowWithTag("other")!.value = nil
          self.form.formRowWithTag("start")!.value = nil
          self.form.formRowWithTag("when")!.value = nil
          self.form.formRowWithTag("problem")!.value = nil
          
          self.tableView.reloadData()
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
  
  func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func finishedLoggingIn() {
    dismissViewControllerAnimated(true, completion: nil)
    
    let user = PFUser.currentUser()
    
    self.user = user
    
    if let phone = user!.objectForKey("phone") as? String {
      
    }
    else {
      let completeSignUpViewController = storyboard?.instantiateViewControllerWithIdentifier("CompleteSignUp") as! CompleteSignUpViewController
      
      completeSignUpViewController.delegate = self
      
      presentViewController(completeSignUpViewController, animated: true, completion: nil)
    }
  }
  
  func finishedSigningUp() {
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
