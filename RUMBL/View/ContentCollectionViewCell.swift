//
//  ContentCollectionViewCell.swift
//  RUMBL
//
//  Created by ds-mayur on 12/10/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var thumbImageView       : UIImageView!
    @IBOutlet weak var activityIndicator    : UIActivityIndicatorView!
    
    //MARK:- Variables
    fileprivate let imageCache      = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        
        //Setting up the UI Elements
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }
    
    //Setting up the UI Element
    func setUI(){
        
        //Setting up the cell content
        self.contentView.layer.cornerRadius  = 15.0
        self.contentView.layer.masksToBounds = true
    }
    
    //Setting up the activity loader
    func setupActivityLoader(){
        
        //Starting the activity indicator
        activityIndicator.startAnimating()
        
        //Hide the activity loader when stopped
        activityIndicator.hidesWhenStopped = true
    }
    
    //Setting up the collectionView cell
    func setupCollectionCell(content : Node?, atIndex : Int){
        
        thumbImageView.image = nil
        
        //Setting up the activity loader
        setupActivityLoader()
        
        //self.thumbImageView.image = nil //UIImage(named: "noimageList")
        //self.thumbImageView.image = UIImage(named: "noimageList")
        
//        if let imageFromCache = imageCache.object(forKey: content?.video?.encodeURL as NSString? ?? "" as NSString) {
//
//            print("Loading Cache: \(content?.video?.encodeURL as NSString? ?? "" as NSString)")
//
//            //Stop the activity loader since image is loaded
//            self.activityIndicator.stopAnimating()
//
//            //Assign cached image to thumbnail
//            self.thumbImageView.image = imageFromCache
//
//            return
//
//        }
        
 //       fetchThumbnailImage(content: content)
        
        Utility.loadThumbnailFromMp4(videoUrl: content?.video?.encodeURL ?? "") { (thumbnailImage) in
            
            DispatchQueue.main.async {
                //Stop Activity loader
                self.activityIndicator.stopAnimating()
                
                //Setting the image
                self.thumbImageView.image = thumbnailImage
            }
        }
        
    }
    
    //Load image from the video file
    func fetchThumbnailImage(content : Node?){
        
        //Generate image from the video url
        Utility.generateThumbnail(videoUrl: content?.video?.encodeURL ?? "") { (image) in
            //Setting image to ImageView on main thread
            DispatchQueue.main.async {
                
                print("Caching: \(content?.video?.encodeURL as NSString? ?? "" as NSString)")
                
                //Stop the activity loader since image is loaded
                self.activityIndicator.stopAnimating()
                
                //Assigning image to imageView
                guard let loadedImage = image else { return }
                self.thumbImageView.image = loadedImage
                
                //Caching the image
                self.imageCache.setObject(loadedImage, forKey: content?.video?.encodeURL as NSString? ?? "" as NSString)
            }
        }
    }
}
