//
//  ViewController.swift
//  RUMBL
//
//  Created by ds-mayur on 12/9/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Variables
    fileprivate var contentModel : [ContentModel]?
    
    fileprivate var tableViewCellIdentifier      = "tableCell"
    fileprivate var collectionViewCellIdentifier = "collectionCell"
    
    //CollectionView Variables
    fileprivate var itemsPerRow     : CGFloat   = 3 // Collection View Number Of Grid In Single Row
    fileprivate let sectionInsets   = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 8.0, right: 8.0)    // Collection View Grid Padding
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the UI Elements
        setUI()
    }
    
    //MARK:- Setting Up UI
    func setUI(){
        
        //Setting up the navigation bar title
        self.title = Constants.exploreScreenTitle
        
        //Load Json from file
        loadJson()
    }
    
    /*
      - This method will load the json from the file
    */
    func loadJson(){
        contentModel = Utility.readJSONFromFile(fileName: Constants.jsonFileName)
    }
    
}

//MARK:- Extension Methods

//MARK: TableView Methods
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier) as? ViewControllerTableViewCell else{
            return UITableViewCell()
        }
        
        //Setting the tableView cell
        cell.setupTableViewCell(content: contentModel?[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? ViewControllerTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected table view row \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0
    }
}

//MARK: CollectionView Methods
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentModel?[collectionView.tag].nodes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as? ContentCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //Setting up the cell
        cell.setupCollectionCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Video Position \(indexPath.item)")
    }
}

//MARK: UICollectionViewDelegateFlowLayout Methods
extension ViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //Fetching width of the thumbnail
        let widthOfThumbnail   = Utility.calculateWidthOfTheThumbnail(numberOfItems: itemsPerRow, margin: sectionInsets.left)
        
        //Fetching height of the thumbnail
        let heightOfThumbnail  = Utility.calculateHeightOfTheThumbnail(width: widthOfThumbnail)
        
        //Return the size of the thumbnail
        return CGSize(width: widthOfThumbnail, height: heightOfThumbnail)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
