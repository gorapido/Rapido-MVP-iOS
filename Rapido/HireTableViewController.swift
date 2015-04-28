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

protocol SessionNVCDelegate {
  func signedInSuccessfully()
}

class HireTableViewController: UITableViewController, SessionNVCDelegate {
  
  let categories = ["HVAC", "Plumbing", "Electricity", "Other"]
  var situation = Situation.Empty
  var sessionNVC: UINavigationController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "activateSituation", name: "jobSituation", object: nil);
    activateSituation()
  }
  
  override func viewWillAppear(animated: Bool) {
    var user = PFUser.currentUser()
    
    if user == nil {
      sessionNVC = storyboard?.instantiateViewControllerWithIdentifier("sessionNVC") as? UINavigationController
      
      var signInVC = sessionNVC?.viewControllers.first as! SignInViewController
      
      signInVC.delegate = self
      
      presentViewController(sessionNVC!, animated: true, completion: nil)
    }
    else {
      if situation != .Empty {
        navigationController?.setNavigationBarHidden(true, animated: false)
      }
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
  
  func signedInSuccessfully() {
    sessionNVC?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func activateSituation()
  {
    navigationController?.popToRootViewControllerAnimated(false)
    switch situation {
    case .Empty:
      navigationController?.setNavigationBarHidden(false, animated: false)
      break
    case .Pending:
      activateViewControllerWithIdentifier("pendingVC")
      break
    default:
      break
    }
  }
  
  func activateViewControllerWithIdentifier(identifier: String) {
    let destinationVC = storyboard?.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
    
    navigationController?.pushViewController(destinationVC, animated: false)
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
