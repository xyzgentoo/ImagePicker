//
//  PhotoFilterViewController.swift
//  ImagePicker
//
//  Created by CCA on 8/6/14.
//  Copyright (c) 2014 CCA. All rights reserved.
//

import UIKit
import Photos

protocol PhotoSelectedDelegate {
    func photoSelected(asset : PHAsset) -> Void
}

class PhotoFilterViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var delegate : PhotoSelectedDelegate?
    var imageAsset : PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageManager = PHImageManager()

        
        if let asset = imageAsset? {
            imageManager.requestImageForAsset(self.imageAsset, targetSize: self.imageView.frame.size, contentMode: PHImageContentMode.AspectFill, options: nil) { (result : UIImage!, info : [NSObject : AnyObject]!) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.imageView.image = result
                })
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectedPhoto(sender: AnyObject) {
        if let d = self.delegate? {
            d.photoSelected(self.imageAsset!)
        }
        self.navigationController.popToRootViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
