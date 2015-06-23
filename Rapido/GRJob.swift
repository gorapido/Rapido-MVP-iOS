//
//  GRJob.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/22/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit

class GRJob: PFObject, PFSubclassing {
  
  class func parseClassName() -> String {
    return "Job"
  }
 
  var user: GRUser {
    get {
      return valueForKey("user") as! GRUser
    }
    set {
      setValue(newValue, forKey: "user")
    }
  }
  
  var start: NSDate? {
    get {
      return valueForKey("start") as? NSDate
    }
    set {
      setValue(newValue, forKey: "start")
    }
  }
  
  var problem: String? {
    get {
      return valueForKey("problem") as? String
    }
    set {
      setValue(newValue, forKey: "problem")
    }
  }
  
  var category: String? {
    get {
      return valueForKey("category") as? String
    }
    set {
      setValue(newValue, forKey: "category")
    }
  }
  
}
