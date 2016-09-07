//
//  FSImageDetailViewController.swift
//  FlickerSample
//
//  Created by Kamal Harariya on 9/3/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class FSImageDetailViewController: UIViewController {

    /** Image name outlet. */
    @IBOutlet var imageName: UILabel!
    
    /** Total Views. */
    @IBOutlet var totalViews: UILabel!
    
    /** Format Label. */
    @IBOutlet var formatLabel: UILabel!
    
    /** Image View. */
    @IBOutlet var imageView: UIImageView!
    
    /** Image Title. */
    var imageTitle = ""
    
    /** Image Format. */
    var format = ""
    
    /** Total Views. */
    var totalViewsString = ""
    
    /** Image data. */
    var imageData: NSData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageName.text = imageTitle
        formatLabel.text = format
        totalViews.text = totalViewsString
        imageView.image = UIImage(data: imageData)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
