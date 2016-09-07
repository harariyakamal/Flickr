//
//  FSRootViewController.swift
//  FlickerSample
//
//  Created by Kamal Harariya on 9/1/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

let padding: CGFloat = 10.0

class FSRootViewController: UICollectionViewController {
    
    /** An Array that holds the image info. */
    var imageArray = [NSDictionary]()
    
    /** An Array that holds the image details. */
    var imageDetailsArray = [NSDictionary?]()
    
    /** An array that holds the */
    var imageDataArray: Array<NSData?> = []
    
    /** selected image data. */
    private var selectedImageData: NSData?
    
    /** Selected Image Details. */
    private var selectedImageDetails: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = padding
        collectionView?.collectionViewLayout = layout
        
        // Get list of photos from Galary. 
        getImageList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageList() {
        let connection = FSHttpConnection()
        weak var weakSelf: FSRootViewController! = self
        connection.makeHttpWithRequestURL(galaryListURL) { (error, response) in
            if let err = error {
                // Handle Error here.
                print(err)
                FSAlertController.showAlertWithMessage(ErrorStringMessage, fromController: self)
            } else {
                if response!["stat"] as! String == "fail" {
                    FSAlertController.showAlertWithMessage(response!["message"] as! String, fromController: self)
                } else {
                    let photoResponse = response![PhotosKey] as? NSDictionary
                    
                    if let photos = photoResponse {
                        if (photos[TotalKey] as? NSInteger) > 0 {
                            let allPhotos = photos[PhotoKey] as! NSArray
                            for photo in allPhotos {
                                weakSelf.imageArray.append(photo as! NSDictionary)
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                weakSelf.collectionView?.reloadSections(NSIndexSet(index: 0))
                            })
                            weakSelf.getImageDetails()
                        } else {
                            FSAlertController.showAlertWithMessage(NoImageString, fromController: self)
                        }
                    } else {
                        FSAlertController.showAlertWithMessage(ErrorStringMessage, fromController: self)
                    }
                }
            }
        }
    }
    
    func getImageDetails() {
        weak var weakself: FSRootViewController! = self
        let connection = FSHttpConnection()
        for (index, photo) in imageArray.enumerate() {
            imageDataArray.append(nil)
            imageDetailsArray.append(nil)
            let photoId = photo[IdKey] as! String
            let urlString = String(format: photoURL, photoId)

            connection.makeHttpRequestForImageDetailsAtIndex(index, urlString: urlString, completionBlock: { (imageDetailIndex, error, response) in
                if error == nil {
                    if response!["stat"] as! String == "fail" {
                        FSAlertController.showAlertWithMessage(response!["message"] as! String, fromController: self)
                    } else {
                        let imageDetail = response![PhotoKey] as? NSDictionary
                        self.imageDetailsArray.replaceObjectAtIndex(imageDetailIndex, withObject: imageDetail)
                        dispatch_async(dispatch_get_main_queue(), {
                            let indexPath = NSIndexPath(forRow: imageDetailIndex, inSection: 0)
                            weakself.collectionView?.reloadItemsAtIndexPaths([indexPath])
                        })
                    }
                } else {
                    // Handle Error. This is special case as there may be more than one transaction failed and we need to show one alert for all the reansactions.
                    FSAlertController.showAlertWithMessage(NoImageString, fromController: self)
                }
            })
        }
    }
    
    // MARK: Navigation.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case ImageDetailSegueIdentifier:
            let detailVC = segue.destinationViewController as! FSImageDetailViewController
            detailVC.imageData = selectedImageData!
            
            if let views = selectedImageDetails![ViewsKey] {
                detailVC.totalViewsString = views as! String
            }
            
            if let format = selectedImageDetails![OriginalformatKey] {
                detailVC.format = format as! String
            }
            
            if let title = selectedImageDetails![TitleKey]![ContentKey]! {
                detailVC.imageTitle = title as! String
            }
        default:
            break
        }
    }
}

/** Extension to handle tableview delegate and datasource methods. */
extension FSRootViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageViewIdentifier, forIndexPath: indexPath) as! FSCollectionViewCell
        
        if imageDataArray.count > indexPath.row {
            if let data = imageDataArray[indexPath.row] {
                cell.cellImage.image = UIImage(data: data)
            } else {
                if let imageDetail = imageDetailsArray[indexPath.row] {
                    let photoId = imageDetail[IdKey]!
                    let farmId = imageDetail[FarmKey]!
                    let serverId = imageDetail[ServerKey]!
                    let secretKey = imageDetail[SecretKey]!
                    
                    let url = "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secretKey).jpg"
                    let connection = FSHttpConnection()
                    connection.makeRequestForImageAtIndex(indexPath.row, requestUrl: url, completion: { (error, imageDataIndex, response) in
                        dispatch_async(dispatch_get_main_queue(), {
                            if error == nil && response != nil {
                                self.imageDataArray.replaceObjectAtIndex(imageDataIndex, withObject: response)
                                cell.cellImage.image = UIImage(data: response!)
                            } else {
                               cell.cellImage.image = UIImage(named: PlaceholderImage)
                            }
                        })
                    })
                } else {
                    cell.cellImage.image = UIImage(named: PlaceholderImage)
                }
            }
        } else {
            cell.cellImage.image = UIImage(named: PlaceholderImage)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSize(width: width, height: height)
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        // Rearranging image details. 
        let sourceImageDetail = imageDetailsArray[sourceIndexPath.row]
        imageDetailsArray.removeAtIndex(sourceIndexPath.row)
        imageDetailsArray.insert(sourceImageDetail, atIndex: destinationIndexPath.row)
        
        // Rearrange image data Array
        let sourceImageData = imageDataArray[sourceIndexPath.row]
        imageDataArray.removeAtIndex(sourceIndexPath.row)
        imageDataArray.insert(sourceImageData, atIndex: destinationIndexPath.row)
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    // MARK: Delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedImageData = imageDataArray[indexPath.row]
        selectedImageDetails = imageDetailsArray[indexPath.row]
        performSegueWithIdentifier(ImageDetailSegueIdentifier, sender: nil)
    }
}
