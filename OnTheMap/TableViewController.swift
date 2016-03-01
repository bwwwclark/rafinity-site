//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Benjamin Clark  on 2/15/16.
//  Copyright © 2016 Benjamin Clark . All rights reserved.
//



import UIKit




class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var otmTableView: UITableView!

    var session: NSURLSession!
    var appDelegate: AppDelegate!
    var information: [StudentInformation] = [StudentInformation]()
    //var studentInfo = parsedResults.valueForKey("results") as! [[String : AnyObject]]
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        otmTableView.delegate = self
        otmTableView.dataSource = self
        
       
}
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        getStudentsLocations()
        otmTableView.reloadData()
        print(information)
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        let count = StudentInformationClient.sharedInstance().studentInformationArray.count
        print(count)
        return count
        
        
    }
    
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 10
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get the cell */
        let cell = tableView.dequeueReusableCellWithIdentifier("otmTableViewCell", forIndexPath: indexPath) as UITableViewCell
         let student = StudentInformationClient.sharedInstance().studentInformationArray[indexPath.row]
        
        print(student.firstName)
        print(student.lastName)
        print(student.mediaURL)
        
        cell.textLabel!.text = (student.firstName)! + " " + (student.lastName)!
        cell.detailTextLabel!.text = student.mediaURL!
        
        /* Set the cell properties */
        print(StudentInformationClient.sharedInstance().studentInformationArray)
        
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let app = UIApplication.sharedApplication()
        if let URLtoOpen = tableView.cellForRowAtIndexPath(indexPath)?.detailTextLabel?.text {
            let isValidURL = app.openURL(NSURL(string: URLtoOpen)!)
            
            //Display an alertView if the URL can't be opened
            if !isValidURL {
                let alert = UIAlertController(title: "Error", message: "Invalid URL", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                dispatch_async(dispatch_get_main_queue(), {self.presentViewController(alert, animated: true, completion: nil)})
            }
            
        }
//        let student = information[indexPath.row]
//        
//        /* Open Safari at the media url of the selected student if valid */
//        if (student.mediaURL != nil) {
//            UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL!)!)
//            
//        } else {
//          print("URL cannot be loaded")
//        }
    }

    func getStudentsLocations() {
        
       ParseClient.sharedInstance().getStudentLocations("100", completionHandler: { error in
            
            if let error = error {
                print("Error retrieving annotations from Parse: \(error)")
                
            } else if !StudentInformationClient.sharedInstance().studentInformationArray.isEmpty {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.otmTableView.reloadData()
                })
            } else {
                print("error- no student information downloaded")
            }
        })
        
}
}

        
//                dispatch_async(dispatch_get_main_queue()) {
//                    
//                    if error.code == 0 {
//                        
//                        let title = "Network Error!"
//                        let message = "Error connecting to Parse. Check your Internet connection!"
//                        let actionTitle = "OK"
//                        
//                        ConfigUI.configureAndPresentAlertController(self, title: title, message: message, actionTitle: actionTitle)
//                        
//                    } else {
//                        
//                        let title = "Error!"
//                        let message = "Error getting students information from Parse!"
//                        let actionTitle = "OK"
//                        
//                        ConfigUI.configureAndPresentAlertController(self, title: title, message: message, actionTitle: actionTitle)
//                    }
//                }
//            }
//        }
    



//    extension TableViewController: UITableViewDelegate, UITableViewDataSource {
//        
//        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//            
//            /* Get cell type */
//            let cellReuseIdentifier = "otmTableViewCell"
//            //let location = self.locations[indexPath.row]
//            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
//            
//            /* Set cell defaults */
//            //cell.textLabel!.text =  location.title
//            //cell.detailTextLabel?.text = //location.mediaURL
//            
//            return cell
//        }

