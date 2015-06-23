//
//  GRCompany.swift
//  Rapido
//
//  Created by Alexander Hernandez on 6/13/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

class GRCompany: PFObject {
  
  var logo: PFFile? {
    get {
      return valueForKey("logo") as? PFFile
    }
    set {
      self["logo"] = newValue
    }
  }
  
  var name: String? {
    get {
      return valueForKey("name") as? String
    }
    set {
      setValue(newValue!, forKey: "name")
    }
  }
  
  var site: String? {
    get {
      return valueForKey("site") as? String
    }
    set {
      setValue(newValue!, forKey: "site")
    }
  }
  
  var phone: String? {
    get {
      return valueForKey("phone") as? String
    }
    set {
      setValue(newValue!, forKey: "phone")
    }
  }
  
  var category: String? {
    get {
      return valueForKey("category") as? String
    }
    set {
      setValue(newValue!, forKey: "category")
    }
  }
  
  var summary: String? {
    get {
      return valueForKey("summary") as? String
    }
    set {
      setValue(newValue!, forKey: "summary")
    }
  }
  
}
