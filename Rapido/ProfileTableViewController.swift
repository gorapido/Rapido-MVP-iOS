//
//  ProfileViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/12/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfileTableViewController: UITableViewController, UIActionSheetDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
  let manager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let user = PFUser.currentUser() {
      let q = PFQuery(className: "Employee")
      
      q.whereKey("user", equalTo: user)
      
      q.findObjectsInBackgroundWithBlock({ (employees: [AnyObject]?, err: NSError?) -> Void in
        if let employee = employees?.first as? PFObject {
          if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.manager.requestAlwaysAuthorization()
          }
        }
        else {
          self.manager.requestWhenInUseAuthorization()
        }
        
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
      })
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
    if indexPath.section == 3 && indexPath.row == 0 {
      PFUser.logOut()
      
      tabBarController?.selectedIndex = 0
    }
    else if indexPath.section == 1 {
      if (indexPath.row == 2) {
        var alert = UIAlertController(title: "Sign In to Rapido", message: "Enter your Rapido password to continue.", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ passwd in
          passwd.secureTextEntry = true
          passwd.placeholder = "password"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default) { action in
          let passwd = alert.textFields![0] as! UITextField;
          var user = PFUser.currentUser()!
          
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
    else if indexPath.section == 0 && indexPath.row == 0 {
      let imageActionSheet = UIActionSheet()
      
      imageActionSheet.delegate = self
      
      imageActionSheet.addButtonWithTitle("Take selfie")
      imageActionSheet.addButtonWithTitle("Choose existing photo")
      imageActionSheet.addButtonWithTitle("Cancel")
      
      imageActionSheet.cancelButtonIndex = 2
      
      imageActionSheet.showInView(self.view)
    }
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
    let user = PFUser.currentUser()
    
    let q = PFQuery(className: "Employee")
    
    q.whereKey("user", equalTo: user!)
    
    q.findObjectsInBackgroundWithBlock { (employees: [AnyObject]?, error: NSError?) -> Void in
      if let employee = employees?.first as? PFObject {
        PFGeoPoint.geoPointForCurrentLocationInBackground({ (coordinates: PFGeoPoint?, err: NSError?) -> Void in
          employee["coordinates"] = coordinates
          
          employee.saveInBackgroundWithBlock({ (success: Bool, err: NSError?) -> Void in
            
          })
        })
      }
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
