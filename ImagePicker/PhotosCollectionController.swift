//
//  PhotosCollectionController.swift
//  ImagePicker
//
//  Created by CCA on 8/6/14.
//  Copyright (c) 2014 CCA. All rights reserved.
//

import UIKit
import Photos

class PhotosCollectionController: UIViewController, UICollectionViewDataSource, PhotoSelectedDelegate {
    
    var fetchedAssetResult : PHFetchResult! // set by instantiating class (i.e. ViewController)
    var imageManager : PHCachingImageManager!  // a PHCachingImageManager which returns images from the assets based on options
    var assetGridThumbnailSize : CGSize! // size for each thumbnail needed. Set in viewWillAppear
    var delegate : PhotoSelectedDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        // create the caching image manager
        self.imageManager = PHCachingImageManager()
    }
    
    override func viewWillAppear(animated: Bool) {
        //grab the cell size from our collectionview
        var scale = UIScreen.mainScreen().scale
        var flowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        var cellSize = flowLayout.itemSize
        self.assetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedAssetResult.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as PhotoCell
        
        // load cell's image using the imageManager
        var asset = self.fetchedAssetResult[indexPath.item] as PHAsset // get asset container
        self.imageManager.requestImageForAsset(asset, targetSize: self.assetGridThumbnailSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (result : UIImage!, info : [NSObject : AnyObject]!) -> Void in
            cell.imageView.image = result
        }
        
        return cell
    }
    
    
    func randomColor() -> UIColor {
        var rgb = [255,255,255].map{ CGFloat(arc4random_uniform($0)) / CGFloat(255.0) }
        return UIColor(red: rgb.removeLast(), green: rgb.removeLast(), blue: rgb.removeLast(), alpha: 1.0)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "PhotoFilter" {
            if let pfVC = segue.destinationViewController as? PhotoFilterViewController {
                if let itemCell = sender as? PhotoCell {
                    var indexPath = self.collectionView.indexPathForCell(itemCell)
                    var asset = self.fetchedAssetResult[indexPath.item] as PHAsset
                    pfVC.imageAsset = asset
                    pfVC.delegate = self
                }
                
            }
        }
    }
    
    //MARK: - PhotoSelectedDelegate
    func photoSelected(asset: PHAsset) {
        if let d = self.delegate? {
            d.photoSelected(asset)
        }
    }


}
