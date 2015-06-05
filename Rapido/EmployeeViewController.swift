//
//  EmployeeViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/29/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class EmployeeViewController: UIViewController {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  var delegate: PresentaionDelegate?
  var job: PFObject?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    avatarImageView.layer.masksToBounds = true
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationReceived"), name: "notificationReceived", object: nil)
    
    if let employee = job!["employee"] as? PFObject {
      employee.fetchIfNeeded()
      
      if let user = employee["user"] as? PFUser {
        user.fetchIfNeeded()
        
        let avatar = user["avatar"] as? PFFile
      
        avatar?.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) -> Void in
          if let image = UIImage(data: data!) {
            self.avatarImageView.image = image
          }
        })

        let firstName = user["firstName"] as! String
      
        let lastName = user["lastName"] as! String
      
        nameLabel.text = "\(firstName) \(lastName)"
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func denyTouchUpInside(sender: AnyObject) {
    var alert = UIAlertController(title: "Cancel Job", message: "Are you sure you want to cancel this request?", preferredStyle: .Alert)
    
    alert.addAction(UIAlertAction(title: "Yes", style: .Default) { action in
      job?.deleteInBackgroundWithBlock({ (success: Bool, err: NSError?) -> Void in
        self.delegate?.presentationDidFinish(.Empty)
      })
      })
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
      
      })
    
    presentViewController(alert, animated: true, completion: nil)
  }
  
  func notificationReceived() {
    delegate?.presentationDidFinish(.Empty)
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
