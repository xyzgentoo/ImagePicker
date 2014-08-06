//
//  ViewController.swift
//  ImagePicker
//
//  Created by CCA on 8/5/14.
//  Copyright (c) 2014 CCA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var alertController : UIAlertController!
                            
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertController = UIAlertController(title: "imagePicker", message: "Pick a new image!", preferredStyle: UIAlertControllerStyle.ActionSheet )
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (actionObject) -> Void in
            println("camera action!")
        }
        self.alertController.addAction(cameraAction)
        
        let imageLibraryAction = UIAlertAction(title: "PhotoLibrary", style: UIAlertActionStyle.Default) { (actionObject) -> Void in
            println("library action!")
        }
        self.alertController.addAction(imageLibraryAction)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func pickImage(sender: UIButton) {
        self.presentViewController(self.alertController, animated: true, completion: {
            println("pickImage button callback")
        })
    }
    
    
    

}

