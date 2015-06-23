//
//  GRUser.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/13/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

class GRUser: PFUser {
  
  var avatar: PFFile? {
    get {
      return valueForKey("avatar") as? PFFile
    }
    set {
      self["avatar"] = newValue
    }
  }
  
  var firstName: String? {
    get {
      return valueForKey("firstName") as? String
    }
    set {
      setValue(newValue!, forKey: "firstName")
    }
  }
  
  var lastName: String? {
    get {
      return valueForKey("lastName") as? String
    }
    set {
      setValue(newValue, forKey: "lastName")
    }
  }
  
  var phone: String? {
    get {
      return valueForKey("phone") as? String
    }
    set {
      setValue(newValue, forKey: "phone")
    }
  }
  
  // Address
  
  var street: String? {
    get {
      return valueForKey("street") as? String
    }
    set {
      setValue(newValue, forKey: "street")
    }
  }
  
  var city: String? {
    get {
      return valueForKey("city") as? String
    }
    set {
      setValue(newValue, forKey: "city")
    }
  }
  
  var state: String? {
    get {
      return valueForKey("state") as? String
    }
    set {
      setValue(newValue, forKey: "state")
    }
  }
  
  var postalCode: String? {
    get {
      return valueForKey("postalCode") as? String
    }
    set {
      setValue(newValue, forKey: "postalCode")
    }
  }
  
}
