//
//  OptionsFormViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MessageUI

class OptionsViewController: XLFormViewController, MFMailComposeViewControllerDelegate, LogInViewControllerDelegate, CompleteSignUpViewControllerDelegate {
  
  var user: PFUser?
  
  let mc = MFMailComposeViewController()
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let form = XLFormDescriptor(title: "Options")
    
    let personalSection = XLFormSectionDescriptor()
    
    personalSection.title = "Account"
    
    form.addFormSection(personalSection)
    
    let editProfile = XLFormRowDescriptor(tag: "editProfile", rowType: XLFormRowDescriptorTypeButton, title: "Edit Profile")
    
    editProfile.action.formSelector = "didTouchEditProfile:"
    
    let editAddress = XLFormRowDescriptor(tag: "editAddress", rowType: XLFormRowDescriptorTypeButton, title: "Edit Address")
    
    editAddress.action.formSelector = "didTouchEditAddress:"
    
    let changePassword = XLFormRowDescriptor(tag: "changePassword", rowType: XLFormRowDescriptorTypeButton, title: "Change Password")
    
    changePassword.action.formSelector = "didTouchChangePassword:"
    
    personalSection.addFormRow(editProfile)
    personalSection.addFormRow(editAddress)
    personalSection.addFormRow(changePassword)
    
    let socialSection = XLFormSectionDescriptor()
    
    socialSection.title = "Social"
    
    form.addFormSection(socialSection)
    
    let facebook = XLFormRowDescriptor(tag: "facebook", rowType: XLFormRowDescriptorTypeButton, title: "Like us on Facebook")
    
    facebook.action.formSelector = "didTouchFacebook:"
    
    let twitter = XLFormRowDescriptor(tag: "twitter", rowType: XLFormRowDescriptorTypeButton, title: "Follow us on Twitter")
    
    twitter.action.formSelector = "didTouchTwitter:"
    
    let instagram = XLFormRowDescriptor(tag: "instagram", rowType: XLFormRowDescriptorTypeButton, title: "Follow us on Instagram")
    
    instagram.action.formSelector = "didTouchInstagram:"
    
    let linkedIn = XLFormRowDescriptor(tag: "linkedIn", rowType: XLFormRowDescriptorTypeButton, title: "Connect with us on LinkedIn")
    
    linkedIn.action.formSelector = "didTouchLinkedIn:"
    
    socialSection.addFormRow(facebook)
    socialSection.addFormRow(twitter)
    socialSection.addFormRow(instagram)
    socialSection.addFormRow(linkedIn)
    
    let businessSection = XLFormSectionDescriptor()
    
    businessSection.title = "Business"
    
    form.addFormSection(businessSection)
    
    let rateRapido = XLFormRowDescriptor(tag: "rateRapido", rowType: XLFormRowDescriptorTypeButton, title: "Rate Rapido")
    
    rateRapido.action.formSelector = "didTouchRateRapido:"
    
    let contactUs = XLFormRowDescriptor(tag: "contactUs", rowType: XLFormRowDescriptorTypeButton, title: "Contact Us")
    
    contactUs.action.formSelector = "didTouchContactUs:"
    
    let termsAndAgreement = XLFormRowDescriptor(tag: "termsAndAgreement", rowType: XLFormRowDescriptorTypeButton, title: "Terms & Agreement")
    
    termsAndAgreement.action.formSelector = "didTouchTermsAndAgreement:"
    
    let privacyPolicy = XLFormRowDescriptor(tag: "privacyPolicy", rowType: XLFormRowDescriptorTypeButton, title: "Privacy Policy")
    
    privacyPolicy.action.formSelector = "didTouchPrivacyPolicy:"
    
    businessSection.addFormRow(rateRapido)
    businessSection.addFormRow(contactUs)
    businessSection.addFormRow(termsAndAgreement)
    businessSection.addFormRow(privacyPolicy)
    
    let importantSection = XLFormSectionDescriptor()
    
    form.addFormSection(importantSection)
    
    let signOut = XLFormRowDescriptor(tag: "signOut", rowType: XLFormRowDescriptorTypeButton, title: "Sign Out")
    
    signOut.action.formSelector = "didTouchSignOut:"
    
    importantSection.addFormRow(signOut)
    
    self.form = form
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if let user = PFUser.currentUser() {
      self.user = user
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func didTouchEditProfile(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("EditProfileViewControllerSegue", sender: nil)
  }
  
  func didTouchEditAddress(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("EditAddressViewControllerSegue", sender: nil)
  }
  
  func didTouchChangePassword(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("ChangePasswordViewControllerSegue", sender: nil)
  }
  
  func didTouchSignOut(sender: XLFormRowDescriptor) {
    PFUser.logOut()
    
    //tabBarController?.selectedIndex = 0
    
    let logInController = LogInViewController()
    
    logInController.delegate = self
    logInController.fields = (PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.Facebook)
    
    presentViewController(logInController, animated: true, completion: nil)
  }
  
  func didTouchFacebook(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("WebViewControllerSegue1", sender: "https://www.facebook.com/goRapido")
  }
  
  func didTouchTwitter(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("WebViewControllerSegue1", sender: "https://twitter.com/goRapido")
  }
  
  func didTouchInstagram(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("WebViewControllerSegue1", sender: "https://instagram.com/gorapido.co/")
  }
  
  func didTouchLinkedIn(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("WebViewControllerSegue1", sender: "https://www.linkedin.com/company/9381006")
  }
  
  func didTouchRateRapido(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("WebViewControllerSegue1", sender: "https://www.surveymonkey.com/s/FWCMFBG")
  }
  
  func didTouchContactUs(sender: XLFormRowDescriptor) {
    mc.mailComposeDelegate = self
    mc.setSubject("Contact Rapido")
    mc.setToRecipients(["alex@gorapido.co"])
    
    presentViewController(mc, animated: true, completion: nil)
  }
  
  func didTouchTermsAndAgreement(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("WebViewControllerSegue1", sender: "https://drive.google.com/file/d/0B4E_KqMyCBfMZkxnRUpfSkIxNlk/view?usp=sharing")
  }
  
  func didTouchPrivacyPolicy(sender: XLFormRowDescriptor) {
    performSegueWithIdentifier("WebViewControllerSegue1", sender: "https://drive.google.com/a/gorapido.co/file/d/0B4E_KqMyCBfMYm5QanI2aFZTNlk/view?usp=sharing")
  }
  
  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func finishedLoggingIn() {
    dismissViewControllerAnimated(true, completion: nil)
    
    let user = PFUser.currentUser()
    
    if user?.isNew == true {
      let completeSignUpViewController = storyboard?.instantiateViewControllerWithIdentifier("CompleteSignUp") as! CompleteSignUpViewController
      
      completeSignUpViewController.delegate = self
      
      presentViewController(completeSignUpViewController, animated: true, completion: nil)
    }
  }
  
  func finishSigningUp() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "EditProfileViewControllerSegue" {
      let editProfileViewController = segue.destinationViewController as! EditProfileViewController
      
      editProfileViewController.user = user
    }
    else if segue.identifier == "EditAddressViewControllerSegue" {
      let editProfileViewController = segue.destinationViewController as! EditAddressViewController
      
      editProfileViewController.user = user
    }
    else if segue.identifier == "ChangePasswordViewControllerSegue" {
      let changePasswordViewController = segue.destinationViewController as! ChangePasswordViewController
      
      changePasswordViewController.user = user
    }
    else {
      let webViewController = segue.destinationViewController as! WebViewController
      
      webViewController.url = NSURL(string: sender as! String)
    }
  }
  
  
}
