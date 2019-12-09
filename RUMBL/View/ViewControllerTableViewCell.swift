//
//  ViewControllerTableViewCell.swift
//  RUMBL
//
//  Created by ds-mayur on 12/9/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var collectionView   : UICollectionView!
    
    //MARK: Variables
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Setting up the scroll direction
        setScrollDirection()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Setting up the cell
    func setupTableViewCell(content : ContentModel?){
        
        //Setting up the category title
        titleLabel.text = content?.title ?? ""
    }
    
    //Setting up the collectionView scroll direction
    func setScrollDirection(){
        let layout                          = UICollectionViewFlowLayout()
        layout.scrollDirection              = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    //MARK: Setting collection view data source and delgate methods reference
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}
