//
//  HireViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/18/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol GRLogInViewControllerDelegate: PFLogInViewControllerDelegate {
  func finishedLoggingIn()
}

protocol FinishedPresentationViewControllerDelegate {
  func finishedPresentation()
}

class HireViewController: XLFormViewController, GRLogInViewControllerDelegate, FinishedPresentationViewControllerDelegate {
  
  var user: PFUser?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Hire")
    
    let detailsSection = XLFormSectionDescriptor()
    
    form.addFormSection(detailsSection)
    
    let category = XLFormRowDescriptor(tag: "category", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Category")
    
    category.selectorOptions = ["Plumbing", "Electrical", "Air & Heating", "Massage", "Computer Assistance & Repair", "Web Development", "Mobile App Development", "Other"]
    
    category.required = true
    
    let other = XLFormRowDescriptor(tag: "other", rowType: XLFormRowDescriptorTypeText, title: "What?")
    
    other.required = true
    other.hidden = "NOT $category.value contains 'Other'"
    
    let when = XLFormRowDescriptor(tag: "when", rowType: XLFormRowDescriptorTypeSelectorPush, title: "Start")
    
    when.selectorOptions = ["Now", "Later"]
    when.required = true
    
    let start = XLFormRowDescriptor(tag: "start", rowType: XLFormRowDescriptorTypeDateTime, title: "When?")
    
    start.required = true
    start.hidden = "NOT $when.value contains 'Later'"
    
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
    user = PFUser.currentUser()
    
    if (user != nil) {
      
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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if user == nil {
      user = PFUser.currentUser()
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func didTouchSubmit(sender: XLFormRowDescriptor) {
    tableView.deselectRowAtIndexPath(form.indexPathOfFormRow(sender), animated: true)
    
    if formValidationErrors().count == 0 {
      let job = PFObject(className: "Job")
      
      job["consumer"] = user
      
      let category = formValues()!["category"]!.valueData() as! String
      
      if category == "Other" {
        job["category"] = getFormValue("other")
      }
      else {
        job["category"] = category
      }
      
      if let start = formValues()?["start"] as? NSDate {
        job["start"] = start
      }
      else {
        job["start"] = NSDate()
      }
      
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
      let alert = UIAlertController(title: "Error!", message: "It looks like you left something blank. Make sure everything is filled in.", preferredStyle: UIAlertControllerStyle.Alert)
        
      alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        
      presentViewController(alert, animated: true, completion: nil)
    }
    
    form.formRowWithTag("category").value = nil
    form.formRowWithTag("other").value = nil
    form.formRowWithTag("start").value = nil
    form.formRowWithTag("when").value = nil
    form.formRowWithTag("problem").value = nil
    
    tableView.reloadData()
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
    
    if user?.isNew == true {
      let completeSignUpViewController = storyboard?.instantiateViewControllerWithIdentifier("CompleteSignUp") as! CompleteSignUpViewController
      
      completeSignUpViewController.delegate = self
      
      presentViewController(completeSignUpViewController, animated: true, completion: nil)
    }
  }
  
  func finishedPresentation() {
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
