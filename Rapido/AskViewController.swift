//
//  AskViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/29/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class AskViewController: UIViewController {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  var delegate: PresentaionDelegate?
  var job: PFObject?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationReceived"), name: "notificationReceived", object: nil)
    
    if let consumer = job!["consumer"] as? PFUser {
      consumer.fetchIfNeeded()
      
      let avatar = consumer["avatar"] as? PFFile
      
      avatar?.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) -> Void in
        if let image = UIImage(data: data!) {
          self.avatarImageView.image = image
        }
      })
      
      let firstName = consumer["firstName"] as! String
      
      nameLabel.text = "\(firstName)"
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func acceptTouchUpInside(sender: AnyObject) {
    let user = PFUser.currentUser()
    
    let q = PFQuery(className: "Employee")
    
    q.whereKey("user", equalTo: user!)
    
    q.findObjectsInBackgroundWithBlock { (employees: [AnyObject]?, err: NSError?) -> Void in
      let employee = employees?.first as! PFObject
      
      self.job!["employee"] = employee
      self.job!["start"] = NSDate()
      
      self.job?.saveInBackgroundWithBlock({ (success: Bool, err: NSError?) -> Void in
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("customerVC") as! CustomerViewController
    
        destinationVC.delegate = self.delegate
        destinationVC.job = self.job
    
        self.delegate?.presentationDidFinish(.Customer)
        self.presentViewController(destinationVC, animated: true, completion: nil)
      })
    }
  }
  
  @IBAction func denyTouchUpInside(sender: AnyObject) {
    job?.deleteInBackgroundWithBlock({ (success: Bool, err: NSError?) -> Void in
      self.delegate?.presentationDidFinish(.Empty)
    })
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
