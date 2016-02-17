//
//  Login View Controller.swift
//  OnTheMap
//
//  Created by Benjamin Clark  on 2/14/16.
//  Copyright © 2016 Benjamin Clark . All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {
    
    var session: NSURLSession!
    var appDelegate: AppDelegate!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //get shared URL session
        session = NSURLSession.sharedSession()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
    }
    
    func ViewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        UdacityClient.sharedInstance().postSession(emailTextField.text!, password: passwordTextField.text!) { (sessionID, error) in
            
            if let sessionID = sessionID {
                print("Successful login for Session \(sessionID)")
                UdacityClient.sharedInstance().sessionID = sessionID
                self.completeLogin()
                
              
            } else {
                let alert = UIAlertController(title: "Error", message: "Invalid login or password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            if let error = error {
                
                print("Login failure. error: \(error)")
                
            } else {
                print("Login failure. No error returned")
            }
            
    }
    
    }
    
    func completeLogin(){
        dispatch_async(dispatch_get_main_queue(), {
            let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
            self.presentViewController(tabBarController, animated: true, completion: nil)
        })
    }
}

