//
//  Udacity Constants.swift
//  OnTheMap
//
//  Created by Benjamin Clark  on 2/14/16.
//  Copyright © 2016 Benjamin Clark . All rights reserved.
//

import Foundation

class UdacityConstants : AnyObject{
    
    struct Constants {
        //Udacity URL
        static let UdacityBaseURLSecure: String = "https://www.udacity.com/api/"
        

    }
    
      struct Methods {
    // MARK: Udacity Authentication
    static let Session = "session"
    
    // MARK: Public User Data
    static let AuthenticationTokenNew = "authentication/token/new"
    
    }
    
    struct JSONBodyKeys {
        
        //Udacity Keys
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        static let account = "account"
        
        
    }
    
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Udacity Authorization
        static let RequestToken = "request_token"
        static let Session = "session"
        static let sessionID = "id"
        static let account = "account"
        static let key = "key"
        
        // MARK: Udacity Account
        static let UserID = "id"
    }


}
