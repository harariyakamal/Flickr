//
//  FSAlertController.swift
//  FlickerSample
//
//  Created by Kamal Harariya on 9/3/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

import UIKit

class FSAlertController: UIAlertController {
    
    class func showAlertWithMessage(message: String, fromController controller: UIViewController) {
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "Alert!!!", message: message, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(cancelAction)
            controller.presentViewController(alertController, animated: true, completion: nil)
        })
    }
}

