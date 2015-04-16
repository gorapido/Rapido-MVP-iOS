//
//  NameTableViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/16/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class NameTableViewController: UITableViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var user = PFUser.currentUser()!
        var firstName = user["firstName"] as! String
        var lastName = user["lastName"] as! String
        
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    */

    @IBAction func firstNameEditingDidEnd(sender: AnyObject) {
        var firstName = firstNameTextField.text
        var user = PFUser.currentUser()
        
        user?.setValue(firstName, forKey: "firstName")
        user?.saveInBackgroundWithBlock { (success: Bool, err: NSError?) -> Void in
            if success {
                
            }
            else {
                println(err)
            }
        }
    }
    
    @IBAction func lastNameEditingDidEnd(sender: AnyObject) {
        var lastName = lastNameTextField.text
        var user = PFUser.currentUser()
        
        user?.setValue(lastName, forKey: "lastName")
        user?.saveInBackgroundWithBlock { (success: Bool, err: NSError?) -> Void in
            if success {
                
            }
            else {
                println(err)
            }
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
