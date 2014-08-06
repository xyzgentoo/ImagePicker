//
//  ViewController.swift
//  ImagePicker
//
//  Created by CCA on 8/5/14.
//  Copyright (c) 2014 CCA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var alertController : UIAlertController!
    var imagePickerController : UIImagePickerController!
                            
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // setup imagePickerController
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.delegate = self
        
        // setup alertController
        self.setupAlertController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupAlertController() {
        self.alertController = UIAlertController(title: "imagePicker", message: "Pick a new image!", preferredStyle: UIAlertControllerStyle.ActionSheet )
        
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
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(self.imagePickerController, animated: true, completion: {
                println("image picker block: library")
            })
            
        }
        
        self.alertController.addAction(imageLibraryAction)
        let cancelAlert = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (actionObject) -> Void in
            println("Cancel")
        }
        self.alertController.addAction(cancelAlert)
    }
    
    @IBAction func pickImage(sender: UIButton) {
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
    

}

