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
    
    var imageAsset : PHAsset?
    var delegate : PhotoSelectedDelegate?
    
    let adjustmentFormatterIndentifier = "com.filterappdemo.cf"
    let adjustmentFormatCurrentVersion = "1.0"
    let context = CIContext(options: nil) // expensive to create each time.. do once!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
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
    
    @IBAction func selectedPhoto(sender: AnyObject) {
        if let d = self.delegate? {
            d.photoSelected(self.imageAsset!)
        }
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    
    func createFilter(filterName : String, selectedAsset : PHAsset) {
        
        // Get options
        var options = PHContentEditingInputRequestOptions()
        
        
        // **** set Adjustment data flag ***
        // When an asset is edited, Photos stores a PHAdjustmentData object provided by the app or extension that edited the asset. 
        // This object provides all information necessary to reconstruct the edited asset using the original asset data.
        // When your app requests to edit an asset, Photos calls this block to inquire whether your app can handle the asset’s past adjustments.
        options.canHandleAdjustmentData = {(adjustmentData : PHAdjustmentData!) -> Bool in
            //QUESTION: not sure where the adjustmentData.formatIdentifier gets set
                return adjustmentData.formatIdentifier == self.adjustmentFormatterIndentifier && adjustmentData.formatVersion == self.adjustmentFormatCurrentVersion
        }
        
        // request an EditingInput from the PHAsset
        selectedAsset.requestContentEditingInputWithOptions(options, completionHandler: { (contentEditingInput : PHContentEditingInput!, info : [NSObject : AnyObject]!) -> Void in
            // get and convert image to CIImage
            var url = contentEditingInput.fullSizeImageURL
            var orientation = contentEditingInput.fullSizeImageOrientation
            var ciImage = CIImage(contentsOfURL: url).imageByApplyingOrientation(orientation)
            
            // create filter
            var vintageFilter = CIFilter(name: filterName)
            vintageFilter.setDefaults()
            vintageFilter.setValue(ciImage, forKey: kCIInputImageKey)
            //vintageFilter.setValue(1.0, forKey: kCIInputIntensityKey)
            
            // *** Computation happens here ****
            // define output image
            var outputImage = vintageFilter.outputImage
            
            // render output to CGImage... because CIImage seems to be buggy if converted to UIImage
            var cgOut = self.context.createCGImage(outputImage, fromRect: outputImage.extent())
            
            var finalImage = UIImage(CGImage: cgOut)
            // make jpeg for saving
            var jpegData = UIImageJPEGRepresentation(finalImage, 0.8)
            
            //**** Create Adjustment Data ***
            
            var adjustmentData = PHAdjustmentData(formatIdentifier: self.adjustmentFormatterIndentifier, formatVersion: self.adjustmentFormatCurrentVersion, data: jpegData)
            
        // To complete the edit:
            
        // 1)  create a PHContentEditingOutput object from the editing input to provide the edited asset data.
            var contentEditingOutput = PHContentEditingOutput(contentEditingInput: contentEditingInput)
            
            // QUESTION! Is this writing to the file right now?  If not, when does this occur?
            jpegData.writeToURL(contentEditingOutput.renderedContentURL, atomically: true)
            
            // canHandleAdjustment data is probably called here.  Expect an error if the handler evals to false
            contentEditingOutput.adjustmentData = adjustmentData
            
        // 2) Then, commit the edit by posting a change block to the shared PHPhotoLibrary object.
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                // 3) In the block, create a PHAssetChangeRequest object and set its contentEditingOutput property to the editing output you created.
                var request = PHAssetChangeRequest(forAsset: selectedAsset)
                request.contentEditingOutput = contentEditingOutput
            
                }, completionHandler: { (success : Bool, err : NSError!) -> Void in
                    // completion handler for changed PHAsset
                    if !success{
                        println("Did it")
                    }
                })
            
            })
    }
    
}
