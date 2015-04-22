//
//  JobViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/21/15.
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

class JobViewController: UIViewController {
    
    var situation = Situation.Empty

    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        switch situation {
        case .Empty:
            
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
