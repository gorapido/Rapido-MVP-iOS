//
//  CompaniesQueryTableViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/17/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class CompaniesQueryTableViewController: PFQueryTableViewController {
  
  override init(style: UITableViewStyle, className: String?) {
    super.init(style: style, className: className)
  }

  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    
    parseClassName = "Company"
    
    pullToRefreshEnabled = true
    paginationEnabled = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    parseClassName = "Company"
    
    pullToRefreshEnabled = true
    paginationEnabled = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func queryForTable() -> PFQuery {
    let q = PFQuery(className: parseClassName!)
    
    if objects?.count == 0 {
      // q.cachePolicy =
    }
    
    q.whereKey("category", equalTo: "Air & Heating")
    
    return q
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
    var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? PFTableViewCell
    
    if cell == nil {
      cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
    }
    
    cell!.textLabel?.text = object?["name"] as? String
    cell!.imageView?.image = UIImage(named: "Placeholder")
    cell!.imageView?.file = object?["logo"] as? PFFile
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let company = objects![indexPath.row] as! PFObject
    
    performSegueWithIdentifier("CompanyViewControllerSegue", sender: company)
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if let companyViewController = segue.destinationViewController as? CompanyViewController {
      let company = sender as! PFObject;
      
      companyViewController.company = company
    }
  }
  
}
