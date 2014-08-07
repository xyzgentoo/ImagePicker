//
//  ViewController.swift
//  ImagePicker
//
//  Created by CCA on 8/5/14.
//  Copyright (c) 2014 CCA. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoSelectedDelegate {
    
    var alertController : UIAlertController!
    var imagePickerController : UIImagePickerController!
    
    var selectedAsset : PHAsset?
                            
    @IBOutlet weak var imagePickerButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // setup imagePickerController
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupAlertController() {
        
        self.alertController = UIAlertController(title: "imagePicker", message: "Pick a new image!", preferredStyle: UIAlertControllerStyle.ActionSheet )
        
        // set popOverPresentationController
        if self.alertController.popoverPresentationController {
            self.alertController.popoverPresentationController.sourceView = self.imagePickerButton
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (actionObject) -> Void in
            println("camera action!")
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(self.imagePickerController, animated: true, completion: {
                println("image picker block: camera")
            })
        }
        self.alertController.addAction(cameraAction)
        
        let imageLibraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (actionObject) -> Void in
            println("library action!")
            self.performSegueWithIdentifier("CollectionView", sender: self)
            
        }
        
        self.alertController.addAction(imageLibraryAction)
        let cancelAlert = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (actionObject) -> Void in
            println("Cancel")
        }
        self.alertController.addAction(cancelAlert)
    }
    
    @IBAction func pickImage(sender: UIButton) {
        // setup alertController
        self.setupAlertController()
        
        self.presentViewController(self.alertController, animated: true, completion: {
            println("pickImage button callback")
        })
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        // get image
        for (key, value) in info {
            if value.isKindOfClass(UIImage.self) {
                self.dismissViewControllerAnimated(true, completion: {
                    self.imageView.image = value as UIImage
                })
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "CollectionView" {
            if segue.destinationViewController.isKindOfClass(PhotosCollectionController.self) {
                var collection = segue.destinationViewController as PhotosCollectionController
                // load with Assets
                collection.fetchedAssetResult = PHAsset.fetchAssetsWithOptions(nil)
                collection.delegate = self
            }
        }
    }
    
    //Mark: - PhotoSelectedDelegate
    func photoSelected(asset: PHAsset) {
        if asset != nil {
            var imageManager = PHImageManager()
            imageManager.requestImageForAsset(asset, targetSize: self.imageView.frame.size, contentMode: PHImageContentMode.AspectFill, options: nil) { (result : UIImage!, info : [NSObject : AnyObject]!) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.imageView.image = result
                })
            }
        }
    }

}

