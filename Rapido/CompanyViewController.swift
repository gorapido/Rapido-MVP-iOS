//
//  CompanyViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/13/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class CompanyViewController: UIViewController {
    
    var name: String?
    var summary: String?
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = name
        summaryTextView.text = summary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hireTapped(sender: AnyObject) {
        
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
