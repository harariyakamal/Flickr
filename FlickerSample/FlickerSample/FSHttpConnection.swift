//
//  FSHttpConnection.swift
//  FlickerSample
//
//  Created by Kamal Harariya on 9/2/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class FSHttpConnection: NSObject {
    /** This will make a server call and fetch the response from database. */
    func makeHttpWithRequestURL(urlString: String, completionBlock completionHandler: (error: NSError?, response: [String:AnyObject]?) -> ()) {
        let requestQueue: dispatch_queue_t = dispatch_queue_create("Request Queue", nil)
        FSNetworkActivity.beginNetworkActivity()
        dispatch_sync(requestQueue) {
            let urlRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
            NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
                FSNetworkActivity.endNetworkActivity()
                if error == nil {
                    do {
                        let allResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [String:AnyObject]
                        completionHandler(error: nil, response: allResponse)
                    } catch {
                        print("Error while parsing the response")
                        completionHandler(error: nil, response: nil)
                    }
                } else {
                    completionHandler(error: error, response: nil)
                }
            }).resume()
        }
    }
    
    /** Fetch Image details with image id url. */
    func makeHttpRequestForImageDetailsAtIndex(index: NSInteger, urlString url: String, completionBlock completionHandler: (index: NSInteger, error: NSError?, response: [String:AnyObject]?) -> ()) {
        
        makeHttpWithRequestURL(url) { (error, response) in
            if error == nil {
                // considering that the response is proper. Need to handle the case when the error is coming as a response.
                completionHandler(index: index, error: error, response: response)
            } else {
                completionHandler(index: index, error: error, response: nil)
            }
        }
    }
    
    /** This will make a server call and fetch the Image. */
    func makeRequestForImageAtIndex(index: NSInteger, requestUrl url: String, completion handler: (error: NSError?, index: NSInteger, response: NSData?) -> ()) {
        let requestQueue: dispatch_queue_t = dispatch_queue_create("Request Queue", nil)
        FSNetworkActivity.beginNetworkActivity()
        dispatch_sync(requestQueue) {
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data, response, error) in
                FSNetworkActivity.endNetworkActivity()
                
                guard let data = data where error == nil else{
                    NSLog("Image download error: \(error)")
                    handler(error: nil, index: index, response: nil)
                    return
                }
                
                handler(error: error, index: index, response: data)
            }.resume()
        }
    }
}

