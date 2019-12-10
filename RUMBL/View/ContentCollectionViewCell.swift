//
//  ContentCollectionViewCell.swift
//  RUMBL
//
//  Created by ds-mayur on 12/10/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        
    }
    
    //Setting up the collectionView cell
    func setupCollectionCell(content : Node?){
        
        //Creating the dispatch queue
        let concurrentQueue = DispatchQueue(label: "com.rumbl.loadThumbnail", attributes: .concurrent)
        
        concurrentQueue.async {
            //Creating the placeHolder image and setting it to the imageView
            let placeHolderImageView    = Utility.generateThumbnail(videoUrl: content?.video?.encodeURL ?? "")  //
            
            DispatchQueue.main.async {
                if let thumbnailImage = placeHolderImageView{
                    self.thumbImageView.image = thumbnailImage
                }else{
                    self.thumbImageView.image = UIImage(named: "noimageList")
                }
            }
            
        }
    }
}
