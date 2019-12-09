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
    func setupCollectionCell(){
        
        //Creating the placeHolder image and setting it to the imageView
        let placeHolderImageView    = UIImage(named: "noimageList")
        thumbImageView.image        = placeHolderImageView
    }
    
}
