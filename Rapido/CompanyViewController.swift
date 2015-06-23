//
//  CompanyViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/13/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController {
  
  var company: PFObject?
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var summaryTextView: UITextView!
  @IBOutlet weak var siteButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLabel.text = company?["name"] as? String
    summaryTextView.text = company?["summary"] as? String
    siteButton.setTitle(company?["site"] as? String, forState: .Normal)
  }
  
  override func viewWillAppear(animated: Bool) {
    let logo = company?.valueForKey("logo") as? PFFile;
    
    logo?.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) -> Void in
      let image = UIImage(data: data!)
      
      self.logoImageView.image = image
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func hireTouchUpInside(sender: AnyObject) {
    PFGeoPoint.geoPointForCurrentLocationInBackground() { (coordinates: PFGeoPoint?, err: NSError?) -> Void in
      let job = PFObject(className: "Job")
      
      let user = PFUser.currentUser()
      
      job["consumer"] = user
      job["company"] = self.company
      job["coordinates"] = coordinates
      
      job.saveInBackgroundWithBlock({ (succress: Bool, err: NSError?) -> Void in
        let hireVC = self.navigationController?.viewControllers.first as! HireTableViewController
        
        hireVC.situation = Situation.Pending
        hireVC.job = job
        
        self.navigationController?.popToRootViewControllerAnimated(false)
      })
    }
  }
  
  @IBAction func callTouchUpInside(sender: AnyObject) {
    let phone = company?["phone"] as! String
    let call = NSURL(string: "tel://\(phone)")
    
    UIApplication.sharedApplication().openURL(call!)
  }
  
  @IBAction func siteTouchUpInside(sender: AnyObject) {
    performSegueWithIdentifier("WebViewControllerSegue", sender: company?["site"])
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
    if segue.identifier == "WebViewControllerSegue" {
      let wc = segue.destinationViewController as! WebViewController
      
      wc.url = NSURL(string: sender as! String)
    }
  }
  
}
