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

protocol JobDelegate {
  func situationEnded()
}

class JobViewController: UIViewController, JobDelegate {
  
  var destinationVC: UIViewController?
  var situation = Situation.Empty
  
  @IBOutlet var containerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    switch situation {
    case .Empty:
      let emptyVC = storyboard?.instantiateViewControllerWithIdentifier("emptyVC") as! UIViewController
      
      navigationController?.pushViewController(emptyVC, animated: false)
      break
    case .Pending:
      let pendingVC = storyboard?.instantiateViewControllerWithIdentifier("pendingVC") as! UIViewController
      
      navigationController?.pushViewController(pendingVC, animated: false)
    default:
      break
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func situationEnded() {
    destinationVC?.navigationController?.popToRootViewControllerAnimated(true)
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
