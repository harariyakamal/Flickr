//
//  FSNetworkActivity.swift
//  FlickerSample
//
//  Created by Kamal Harariya on 9/3/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class FSNetworkActivity: NSObject {

    static var transactionCount: Int32 = 0
    
    class func beginNetworkActivity() {
        OSAtomicAdd32(1, &transactionCount)
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = (transactionCount > 0)
        }
    }
    
    class func endNetworkActivity() {
        OSAtomicAdd32(-1, &transactionCount)
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = (transactionCount > 0)
        }
    }
}
