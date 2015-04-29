//
//  PendingViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/28/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class PendingViewController: UIViewController {
  
  var job: PFObject?
  var delegate: PresentaionDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func cancelTouchUpInside(sender: AnyObject) {
    job?.deleteInBackgroundWithBlock({ (success: Bool, err: NSError?) -> Void in
      self.delegate?.presentationDidFinish(Situation.Empty)
    })
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
