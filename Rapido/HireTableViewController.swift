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
    
    let user = PFUser.currentUser()
    
    let query = PFQuery(className: "Job")
    
    query.whereKey("consumer", equalTo: user!)
    query.whereKeyDoesNotExist("finish")
    
    query.findObjectsInBackgroundWithBlock { (jobs: [AnyObject]?, err: NSError?) -> Void in
      if let job = jobs?.first as? PFObject {
        self.job = job
        
        self.situation = Situation.Pending
      }
    }
    
    let q2 = PFQuery(className: "Employee")
    
    q2.whereKey("user", equalTo: user!)
    
    q2.findObjectsInBackgroundWithBlock { (employees: [AnyObject]?, err: NSError?) -> Void in
      if let employee = employees?.first as? PFObject {
        let q = PFQuery(className:  "Job")
        
        q.whereKey("company", equalTo: employee["company"]!)
        q.whereKeyDoesNotExist("employee")
        
        q.findObjectsInBackgroundWithBlock({ (jobs: [AnyObject]?, err: NSError?) -> Void in
          if let job = jobs?.first as? PFObject {
            self.job = job
            
            self.situation = Situation.Asking
          
            self.activateSituation()
          }
        })
        
        let q3 = PFQuery(className: "Job")
        
        q3.whereKey("employee", equalTo: employee)
        q3.whereKeyDoesNotExist("finish")
        
        q3.findObjectsInBackgroundWithBlock({ (jobs: [AnyObject]?, err: NSError?) -> Void in
          if let job = jobs?.first as? PFObject {
            self.job = job
            
            self.situation = Situation.Customer
            
            self.activateSituation()
          }
        })
      }
    }
    
    activateSituation()
  }
  
  override func viewWillAppear(animated: Bool) {
    var user = PFUser.currentUser()
    
    if user == nil {
      sessionNVC = storyboard?.instantiateViewControllerWithIdentifier("sessionNVC") as? UINavigationController
      
      let signInVC = sessionNVC?.viewControllers.first as! SignInViewController
      
      signInVC.delegate = self
      
      presentViewController(sessionNVC!, animated: true, completion: nil)
    }
    else {
      activateSituation()
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
    case .Customer:
      let destinationVC = storyboard?.instantiateViewControllerWithIdentifier("customerVC") as! CustomerViewController
      
      destinationVC.delegate = self
      destinationVC.job = job
      
      presentationVC = destinationVC
      
      presentViewController(presentationVC!, animated: true, completion: nil)
      break
    default:
      break
    }
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
