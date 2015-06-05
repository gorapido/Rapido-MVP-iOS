//
//  WebViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/4/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
  @IBOutlet weak var webView: UIWebView!
  
  var url: NSURL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.loadRequest(NSURLRequest(URL: url!))
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
