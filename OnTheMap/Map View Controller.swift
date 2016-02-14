//
//  Map View Controller.swift
//  OnTheMap
//
//  Created by Benjamin Clark  on 2/14/16.
//  Copyright © 2016 Benjamin Clark . All rights reserved.
//

import Foundation

import Foundation
import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate{
    
    
    @IBOutlet weak var MapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    var annotation = MKPointAnnotation()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        ParseClient.sharedInstance().getStudentLocations("100", completionHandler: { locations, error in
            
            if let error = error {
                print("Error retrieving annotations from Parse: \(error)")
            } else if let locations = locations {
                for location in locations {
                    self.annotation = ParseClient.sharedInstance().createAnnotationFromStudentInformation(location)
                    self.annotations.append(self.annotation)
                    print(self.annotation.title)
                    print(self.annotation.subtitle)
                    self.MapView.addAnnotations(self.annotations)
                    print("added to map")
                }
                
            } else {
                print("Error - no annotations downloaded from Parse")
            }
        })
        
        MapView.delegate = self
        
    }
    
    //delegate method to create pins and add annotations
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        print("MapView function executing")
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: self.annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.self.annotation! = self.annotation
            
        }
        
        return pinView
    }
    
    // delegate method to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
    
    
    
    
    
    //
    //    @IBAction func logout(sender: AnyObject) {
    //
    //        UdacityClient.sharedInstance().logoutWithUdacity(UdacityClient.sharedInstance().sessionID!) { success, error in
    //
    //            if let error = error {
    //                print("Logout failed due to error: \(error)")
    //            } else {
    //
    //                if success {
    //                    // Segue back to login screen
    //                    self.dismissViewControllerAnimated(true, completion: nil)
    //                }
    //            }
    //        }
    
}