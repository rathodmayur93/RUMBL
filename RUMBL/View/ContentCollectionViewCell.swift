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
    @IBOutlet weak var thumbImageView: UIImageView!
    
    //MARK:- Variables
    fileprivate let imageCache      = NSCache<NSString, UIImage>()
    fileprivate var thumbnailImage  : UIImage?
    
    override func awakeFromNib() {
        
    }
    
    //Setting up the collectionView cell
    func setupCollectionCell(content : Node?){
        
        //Creating the dispatch queue
        let concurrentQueue = DispatchQueue(label: "com.rumbl.loadThumbnail", attributes: .concurrent)
        
        concurrentQueue.async {
            //Creating the placeHolder image and setting it to the imageView
            
            if let cacheImage = self.imageCache.object(forKey: content?.video?.encodeURL as NSString? ?? "") {
                self.thumbnailImage = cacheImage
            }else{
            
                self.thumbnailImage    = Utility.generateThumbnail(videoUrl: content?.video?.encodeURL ?? "")  //
                
                DispatchQueue.main.async {
                    if let image = self.thumbnailImage{
                        self.thumbImageView.image = image
                    }else{
                        self.thumbImageView.image = UIImage(named: "noimageList")
                    }
                }
            }
        }
    }
}
