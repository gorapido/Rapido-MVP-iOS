//
//  HireTableViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/13/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

enum Situation {
  case Empty
  case Pending
  case Asking
  case Canceled
  case Customer
  case Employee
  case Review
}

protocol SessionDelegate {
  func signInSuccessfully()
}

protocol PresentaionDelegate {
  func presentationDidFinish(situation: Situation)
}

class HireTableViewController: UITableViewController, SessionDelegate, PresentaionDelegate {
  
  let categories = ["HVAC", "Plumbing", "Electricity", "Other"]
  
  var situation = Situation.Empty
  var sessionNVC: UINavigationController?
  var presentationVC: UIViewController?
  var job: PFObject?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationReceived"), name: "notificationReceived", object: nil)
    
    determineSituation()
  }
  
  override func viewWillAppear(animated: Bool) {
    if let user = PFUser.currentUser() {
      activateSituation()
    }
    else {
      sessionNVC = storyboard?.instantiateViewControllerWithIdentifier("sessionNVC") as? UINavigationController
      
      let signInVC = sessionNVC?.viewControllers.first as! SignInViewController
      
      signInVC.delegate = self
      
      presentViewController(sessionNVC!, animated: true, completion: nil)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("category", forIndexPath: indexPath) as! UITableViewCell
    
    cell.textLabel?.text = categories[indexPath.row]
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var query = PFQuery(className: "Company")
    var category = categories[indexPath.row]
    var companies: [PFObject]?
    
    query.whereKey("category", equalTo: category)
    query.findObjectsInBackgroundWithBlock { (collection: [AnyObject]?, err: NSError?) -> Void in
      companies = collection as? [PFObject]
      
      self.performSegueWithIdentifier("companiesTVCSegue", sender: companies)
    }
  }
  
  func signInSuccessfully() {
    sessionNVC?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func presentationDidFinish(situation: Situation) {
    self.situation = situation
    
    presentationVC?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func determineSituation() {
    if let user = PFUser.currentUser() {
      let consumerJob = PFQuery(className: "Job")
      
      consumerJob.whereKey("consumer", equalTo: user)
      consumerJob.whereKeyDoesNotExist("finish")
      
      consumerJob.getFirstObjectInBackgroundWithBlock { (job: PFObject?, err: NSError?) -> Void in
        if err === nil {
          self.job = job
          
          if job!["employee"] === nil {
            self.situation = .Pending
          }
          else {
            self.situation = .Employee
          }
          
          self.activateSituation()
        }
      }
      
      let employeeJob = PFQuery(className: "Employee")
      
      employeeJob.whereKey("user", equalTo: user)
      
      employeeJob.getFirstObjectInBackgroundWithBlock { (employee: PFObject?, err: NSError?) -> Void in
        if err === nil {
          let unassignedJob = PFQuery(className:  "Job")
          
          let company = employee!["company"] as! PFObject
          
          unassignedJob.whereKey("company", equalTo: company)
          unassignedJob.whereKeyDoesNotExist("employee")
          
          unassignedJob.getFirstObjectInBackgroundWithBlock { (job: PFObject?, err: NSError?) -> Void in
            if err === nil {
              self.job = job
              
              self.situation = .Asking
              
              self.activateSituation()
            }
          }
          
          let currentJob = PFQuery(className: "Job")
          
          currentJob.whereKey("employee", equalTo: employee!)
          currentJob.whereKeyDoesNotExist("finish")
          
          currentJob.getFirstObjectInBackgroundWithBlock { (job: PFObject?, err: NSError?) -> Void in
            if err === nil {
              self.job = job
              
              self.situation = .Customer
              
              self.activateSituation()
            }
          }
        }
      }
    }
  }
  
  func activateSituation()
  {
    navigationController?.popToRootViewControllerAnimated(false)
    
    switch situation {
    case .Pending:
      let destinationVC = storyboard?.instantiateViewControllerWithIdentifier("pendingVC") as! PendingViewController
      
      destinationVC.delegate = self
      destinationVC.job = job
      
      presentationVC = destinationVC
      
      presentViewController(presentationVC!, animated: true, completion: nil)
      break
    case .Asking:
      let destinationVC = storyboard?.instantiateViewControllerWithIdentifier("askVC") as! AskViewController
      
      destinationVC.delegate = self
      destinationVC.job = job
      
      presentationVC = destinationVC
      
      presentViewController(presentationVC!, animated: true, completion: nil)
      break
    case .Canceled:
      let closingVC = presentationVC as! AskViewController
      
      closingVC.delegate?.presentationDidFinish(.Empty)
      break
    case .Customer:
      let destinationVC = storyboard?.instantiateViewControllerWithIdentifier("customerVC") as! CustomerViewController
      
      destinationVC.delegate = self
      destinationVC.job = job
      
      presentationVC = destinationVC
      
      presentViewController(presentationVC!, animated: true, completion: nil)
      break
    case .Employee:
      let destinationVC = storyboard?.instantiateViewControllerWithIdentifier("employeeVC") as! EmployeeViewController
      
      destinationVC.delegate = self
      destinationVC.job = job
      
      presentationVC = destinationVC
      
      presentViewController(presentationVC!, animated: true, completion: nil)
      break
    default:
      break
    }
  }
  
  func notificationReceived() {
    determineSituation()
  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the specified item to be editable.
  return true
  }
  */
  
  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return NO if you do not want the item to be re-orderable.
  return true
  }
  */
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    let companiesTVC = segue.destinationViewController as! CompaniesTableViewController
    let companies = sender as! [PFObject]
    
    companiesTVC.companies = companies
  }
  
  
}
