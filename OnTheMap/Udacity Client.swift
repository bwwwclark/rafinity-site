//
//  Udacity Client.swift
//  OnTheMap
//
//  Created by Benjamin Clark  on 2/14/16.
//  Copyright © 2016 Benjamin Clark . All rights reserved.
//

import Foundation

class UdacityClient: AnyObject {
    
    
    
    var session: NSURLSession
    
    // MARK: Initializers
    
    // MARK: Properties
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    
    init() {
        session = NSURLSession.sharedSession()
    }
    
    func taskForUdacityGetMethod(method: String, completionHandler:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        //Build GET request
        
        let urlString = UdacityConstants.Constants.UdacityBaseURLSecure + method
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        //make request
        
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            
            //GUARD was there an error?
            
            guard error == nil else {
                
                let userInfo = [NSLocalizedDescriptionKey: "There was an error with your Udacity request : \(error)"]
                completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
                return
            }
            
            //GUARD was there a 2XX response?
                
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    if let response = response as? NSHTTPURLResponse {
                        let userInfo = [NSLocalizedDescriptionKey: "Invalid response. Status code: \(response.statusCode)!"]
                        completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
                    } else if let response = response{
                        let userInfo = [NSLocalizedDescriptionKey: "Invalid response. Response: \(response)!"]
                        completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
                        
                    }else {
                        let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
                        completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
                    }
                    return
                }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
                return
            }
            
            /* Parse and use data */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            self.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
        }
        
        //start the request
        task.resume()
        return task
    }

    //MARK: Authentication methods
    
    //    func authenticateWithUdacity(login: String, password: String, completionHandler: (sessionID: String?, error: NSError?) -> Void) {
    //
    //        /* Set up HTTP Body with correct parameters */
    //        let jsonBody =  ["udacity" : [
    //            OTMConstants.JSONBodyKeys.username : login,
    //            OTMConstants.JSONBodyKeys.password : password
    //            ]]
    //
    //        /* Make the request */
    //        taskForUdacityPOSTMethod(OTMConstants.Methods.Session, jsonBody: jsonBody) {
    //            JSONResult, error in
    //            let jsonBody : [String:AnyObject] = [
    //                OTMConstants.JSONBodyKeys.udacity: "udacity",
    //                OTMConstants.JSONBodyKeys.username: login as String,
    //                OTMConstants.JSONBodyKeys.password: password as String,
    //                ]
    //
    //            /* Send error values to completion handler */
    //            if let error = error {
    //                completionHandler(sessionID: nil, error: error)
    //            } else {
    //
    //               // NEED TO FIGURE THIS PART OUT
    //                if let sessionID = JSONResult["sessionID"] as? String {
    //                    completionHandler(sessionID: sessionID, error: nil)
    //
    //                } else {
    //                    completionHandler(sessionID: nil, error: error)
    //                }
    //
    //            }
    //
    //        }
    //
    //
    //    }
    //
    //    func logoutWithUdacity(sessionID: String, completionHandler: (success: Bool, error: NSError?) -> Void) {
    //
    //        /* Make the Udacity DELETE request */
    //        taskForUdacityDELETEMethod(OTMClient.Methods.Session) {result, error in
    //
    //            if let error = error {
    //                completionHandler(success: false, error: error)
    //            } else {
    //                if let session = result[OTMClient.JSONResponseKeys.Session]??[OTMClient.JSONResponseKeys.sessionID] as? String {
    //
    //                    //DELETE method returned a session so set the shared instance sessionID back to nil
    //                    OTMClient.sharedInstance().sessionID = nil
    //                    completionHandler(success: true, error: nil)
    //                    
    //                } else {
    //                    completionHandler(success: false, error: nil)
    //                }
    //                
    //            }
    //        }
    //    }






    ///LEAVING OFF HERE!!


    func taskForUdacityPOSTMethod (method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        // 1. set the parameters
        // var mutableParameters = parameters
        // mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey
        
        // 2. build the URL and configure the request
        
        let urlString = UdacityConstants.Constants.UdacityBaseURLSecure + UdacityConstants.Methods.Session
        
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.HTTPBody =  try!NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            guard (error == nil) else {
                print("there was an error with your request:\(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
            
            //Parse data
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            self.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        
            
            
        }
        task.resume()
        return task
        
    }

    
    func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    // MARK: Shared Instance
    
     class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    


    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    func postSession(username: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void){
        let method = UdacityConstants.Methods.Session
        let jsonBody = [
                UdacityConstants.JSONBodyKeys.udacity : [
                UdacityConstants.JSONBodyKeys.username : username,
                UdacityConstants.JSONBodyKeys.password : password
            ],
        ]
        
        taskForUdacityPOSTMethod(method, jsonBody: jsonBody) { (JSONResult, error) in
            
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let dictionary = JSONResult! [UdacityConstants.JSONResponseKeys.account] as? [String : AnyObject] {
                if let result = dictionary[UdacityConstants.JSONResponseKeys.key] as? String {
                    completionHandler(result: result, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                }
            } else {
                completionHandler(result: nil, error: NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                
            }
        }
    }

}

