//
//  CustomerViewController.swift
//  Rapido
//
//  Created by Alexander Hernandez on 4/29/15.
//  Copyright (c) 2015 Rapido. All rights reserved.
//

import UIKit
import MapKit

class CustomerViewController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  var delegate: PresentaionDelegate?
  var job: PFObject?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let consumer = job!["consumer"] as? PFUser {
      consumer.fetchIfNeeded()
    
      let avatar = consumer["avatar"] as? PFFile
    
      avatar?.getDataInBackgroundWithBlock({ (data: NSData?, err: NSError?) -> Void in
        if let image = UIImage(data: data!) {
          self.avatarImageView.image = image
        }
      })
    
      let firstName = consumer["firstName"] as! String
    
      let lastName = consumer["lastName"] as! String
    
      nameLabel.text = "\(firstName) \(lastName)"
    
      let geoPoint = job!["coordinates"] as! PFGeoPoint
    
      let location = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    
      let span = MKCoordinateSpanMake(0.05, 0.05)
    
      let region = MKCoordinateRegion(center: location, span: span)
    
      mapView.setRegion(region, animated: true)
      
      let annotation = MKPointAnnotation()
      
      annotation.coordinate = location
      annotation.title = "\(firstName)'s location"
      //annotation.subtitle = "1.1 m"
      
      mapView.addAnnotation(annotation)
      
      mapView.selectAnnotation(annotation, animated: true)
    }
  }
  
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "navAV")
    
    annotationView.canShowCallout = true
    
    let navigateButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
    
    annotationView.leftCalloutAccessoryView = navigateButton
    
    return annotationView
  }
  
  func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
    let geoPoint = job!["coordinates"] as! PFGeoPoint
    
    let location = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
  
    let span = MKCoordinateSpanMake(0.05, 0.05)
    
    let region = MKCoordinateRegion(center: location, span: span)
    
    let options = [
      MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: region.center),
      MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: region.span)
    ]
    
    let placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
    
    let mapItem = MKMapItem(placemark: placemark)
    
    mapItem.openInMapsWithLaunchOptions(options)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func closeTouchUpInside(sender: AnyObject) {
    job!["finish"] = NSDate()
    
    job?.saveInBackgroundWithBlock({ (success: Bool, err: NSError?) -> Void in
      self.delegate?.presentationDidFinish(.Empty)
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
