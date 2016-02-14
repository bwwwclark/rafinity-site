//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Benjamin Clark  on 2/14/16.
//  Copyright © 2016 Benjamin Clark . All rights reserved.
//

import UIKit
import Foundation
import MapKit

class ParseClient: AnyObject {
    
    var session: NSURLSession
    
    // MARK: Initializers
    
    // MARK: Properties
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    
    init() {
        session = NSURLSession.sharedSession()
    }

    
    func taskForParseGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        var mutableParameters = parameters
        
        //        mutableParameters[OTMConstants.ParameterKeys.ApiKey] = OTMConstants.Constants.ParseApiKey
        //
        //        mutableParameters[OTMConstants.ParameterKeys.ApplicationID] = OTMConstants.Constants.ParseApplicationID
        
        
        
        
        /* 2/3. Build the URL and configure the request */
        let urlString = ParseConstants.Constants.ParseBaseURLSecure + method + escapedParameters(mutableParameters)
        
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        
        //REMEMBER TO FIX APPLICATION ID AND API KEY WITH CONSTANTS!!!!!
        
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        print(urlString)
        
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                    print(urlString)
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    
    
    
    func getStudentLocations(Limit: String, completionHandler: (locations: [StudentInformation]?, error: NSError?) -> Void) ->NSURLSessionDataTask? {
        
        /* Specify parameters */
        
        
        let parameters = [ParseConstants.ParameterKeys.limit: Limit]
        
        let method : String = ParseConstants.Methods.Location
        
        /* 2. Make the request */
        let task = taskForParseGETMethod(method, parameters: parameters) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            
            if let error = error {
                completionHandler(locations: nil, error: error)
            } else {
                
                if let results = JSONResult[ParseConstants.JSONResponseKeys.LocationResults] as? [[String : AnyObject]] {
                    
                    /* Assign the needed parameters to the StudentInformation objects */
                    var locations = [StudentInformation]()
                    
                    for location in results {
                        
                        /* Create the StudentInformation object from the values retrieved from the JSON */
                        let location = StudentInformation.init(dictionary: location)
                        
                        /* Add the newly created location to the array of locations */
                        locations.append(location)
                    }
                    
                    completionHandler(locations: locations, error: nil)
                } else {
                    completionHandler(locations: nil, error: NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
            
        }
        return task
    }

    func createAnnotationFromStudentInformation(location: StudentInformation) ->MKPointAnnotation {
        
        let annotation = MKPointAnnotation()
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = location.firstName!
        let last = location.lastName!
        let mediaURL = location.mediaURL!
        
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        return annotation
    }
    
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
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
    
    



    
}