//
//  ProfileViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MobileCoreServices
import MessageUI

class ProfileTableViewController: UITableViewController, UIActionSheetDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var availableSwitch: UISwitch!
  
  let manager = CLLocationManager()
  let mc = MFMailComposeViewController()
  
  var isEmployee: Bool?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.userInteractionEnabled = false
    
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    avatarImageView.layer.masksToBounds = true
    
    if let user = PFUser.currentUser() {
        let q = PFQuery(className: "Employee")
        
        q.whereKey("user", equalTo: user)
        
        q.getFirstObjectInBackgroundWithBlock { (employee: PFObject?, err: NSError?) -> Void in
          if err === nil {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
              self.manager.requestAlwaysAuthorization()
            }
            
            self.availableSwitch.on = employee!["available"] as! Bool
            
            self.isEmployee = true
            
            self.tableView.reloadData()
          }
          else {
            self.manager.requestWhenInUseAuthorization()
            
            self.isEmployee = false
          }
          
          self.manager.delegate = self
          
          if self.availableSwitch.on {
            self.manager.startUpdatingLocation()
          }
        }
      
      self.availableSwitch.addTarget(self, action: Selector("availableSwitchChanged:"), forControlEvents: UIControlEvents.ValueChanged)
      
      view.userInteractionEnabled = true
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    if let user = PFUser.currentUser() {
      let avatar = user["avatar"] as? PFFile
      
      avatar?.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) -> Void in
        let image = UIImage(data: data!)
        
        self.avatarImageView.image = image
      })
      
      var firstName = user["firstName"] as! String
      var lastName = user["lastName"] as! String
      var email = user["email"] as! String
      
      nameLabel.text = "\(firstName) \(lastName)"
      emailLabel.text = email
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    if indexPath.section == 0 && indexPath.row == 0 {
      let imageActionSheet = UIActionSheet()
      
      imageActionSheet.delegate = self
      
      imageActionSheet.addButtonWithTitle("Take selfie")
      imageActionSheet.addButtonWithTitle("Choose existing photo")
      imageActionSheet.addButtonWithTitle("Cancel")
      
      imageActionSheet.cancelButtonIndex = 2
      
      imageActionSheet.showInView(self.view)
    }
    else if indexPath.section == 1 {
      if (indexPath.row == 2) {
        var alert = UIAlertController(title: "Sign In to Rapido", message: "Enter your Rapido password to continue.", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ passwd in
          passwd.secureTextEntry = true
          passwd.placeholder = "password"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
          let passwd = alert.textFields![0] as! UITextField
          
          let user = PFUser.currentUser()!
          
          PFUser.logInWithUsernameInBackground(user.email!, password: passwd.text) { (user: PFUser?, err: NSError?) -> Void in
            if user != nil {
              self.performSegueWithIdentifier("passwordTCVSegue", sender: nil)
            }
            else {
              
            }
          }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
          
        })
        
        presentViewController(alert, animated: true, completion: nil)
      }
    }
    else if indexPath.section == 2 {
      if indexPath.row == 0 {
        performSegueWithIdentifier("webViewSegue", sender: "https://www.surveymonkey.com/s/FWCMFBG")
      }
      else if indexPath.row == 1 {
        mc.mailComposeDelegate = self
        mc.setSubject("Contact Rapido")
        mc.setToRecipients(["alex@gorapido.co"])
        
        presentViewController(mc, animated: true, completion: nil)
      }
      else if indexPath.row == 2 {
        performSegueWithIdentifier("webViewSegue", sender: "https://drive.google.com/file/d/0B4E_KqMyCBfMZkxnRUpfSkIxNlk/view?usp=sharing")
      }
      else if indexPath.row == 3 {
        performSegueWithIdentifier("webViewSegue", sender: "https://drive.google.com/a/gorapido.co/file/d/0B4E_KqMyCBfMYm5QanI2aFZTNlk/view?usp=sharing")
      }
    }
    else if indexPath.section == 3 && indexPath.row == 0 {
      PFUser.logOut()
      
      tabBarController?.selectedIndex = 0
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    var height: CGFloat = 44
    
    if indexPath.section == 1 && indexPath.row == 3 {
      let user = PFUser.currentUser()
      
      let q = PFQuery(className: "Employee")
     
      q.getFirstObjectInBackgroundWithBlock { (employee: PFObject?, err: NSError?) -> Void in
        if err === nil {
          height = 0
        }
      }
    }
    
    return height
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 {
      if isEmployee == true {
        return 4
      }
      else {
        return 3
      }
    }
    else if section == 2 {
      return 4
    }
    
    return 1
  }
  
  func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
    let picker = UIImagePickerController()
    
    picker.delegate = self
    picker.allowsEditing = true
    picker.mediaTypes = [kUTTypeImage as NSString]
    
    switch buttonIndex {
    case 0:
      picker.sourceType = UIImagePickerControllerSourceType.Camera
      
      presentViewController(picker, animated: true, completion: nil)
      break
    case 1:
      picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
      
      presentViewController(picker, animated: true, completion: nil)
      break
    default:
      break
    }
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    let user = PFUser.currentUser()
    
    let data = UIImageJPEGRepresentation(image, image.scale) as NSData
    
    let objectId = user?.valueForKey("objectId") as! String
    
    let avatar = PFFile(name: "\(objectId)-avatar.jpg", data: data)
    
    avatar.saveInBackgroundWithBlock { (success: Bool, err: NSError?) -> Void in
      if (success) {
        user?.setObject(avatar, forKey: "avatar")
        
        user?.saveInBackgroundWithBlock({ (success: Bool, err: NSError?) -> Void in
          self.avatarImageView.image = image
        })
      }
    }
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
      manager.startUpdatingLocation()
    }
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    if let user = PFUser.currentUser() {
    
      let q = PFQuery(className: "Employee")
    
      q.whereKey("user", equalTo: user)
    
      q.getFirstObjectInBackgroundWithBlock { (employee: PFObject?, err: NSError?) -> Void in
        if err === nil {
          PFGeoPoint.geoPointForCurrentLocationInBackground { (coordinates: PFGeoPoint?, err: NSError?) -> Void in
            employee!["coordinates"] = coordinates
          
            employee!.saveInBackgroundWithBlock { (success: Bool, err: NSError?) -> Void in
            
            }
          }
        }
      }
    }
  }
  
  func availableSwitchChanged(switchState: UISwitch) {
    let user = PFUser.currentUser()
    
    let q = PFQuery(className: "Employee")
    
    q.whereKey("user", equalTo: user!)
    
    q.getFirstObjectInBackgroundWithBlock { (employee: PFObject?, error: NSError?) -> Void in
      if self.availableSwitch.on {
        employee!["available"] = true
      }
      else {
        employee!["available"] = false
      }
        
      employee!.saveInBackgroundWithBlock { (success: Bool, err: NSError?) -> Void in
          
      }
    }
  }
  
  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "webViewSegue" {
      let wc = segue.destinationViewController as! WebViewController
    
      wc.url = NSURL(string: sender as! String)
    }
  }
  
}
