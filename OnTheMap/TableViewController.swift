//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Benjamin Clark  on 2/15/16.
//  Copyright © 2016 Benjamin Clark . All rights reserved.
//

import Foundation

import UIKit




class TableViewController: UIViewController{
   
    @IBOutlet weak var otmTableView: UITableView!

    var session: NSURLSession!
    var appDelegate: AppDelegate!
    
    var locations: [StudentInformation] = [StudentInformation]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        ParseClient.sharedInstance().getStudentLocations("100", completionHandler: { locations, error in
            
            if let error = error {
                print("Error retrieving annotations from Parse: \(error)")
            } else if let locations = locations {
                for location in locations {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.otmTableView.reloadData()
                    }
                }
                
            } else {
                print("Error - no annotations downloaded from Parse")
            }
        })
    }
}


    extension TableViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            /* Get cell type */
            let cellReuseIdentifier = "otmTableViewCell"
            let location = self.locations[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
            
            /* Set cell defaults */
            cell.textLabel!.text = location.title
            cell.detailTextLabel?.text = location.mediaURL
            cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
            
            return cell
        }
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.locations.count
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 100
        }
}

