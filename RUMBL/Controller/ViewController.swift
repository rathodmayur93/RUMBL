//
//  ViewController.swift
//  RUMBL
//
//  Created by ds-mayur on 12/9/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- Variables
    fileprivate var contentModel : [ContentModel]?
    
    fileprivate var tableViewCellIdentifier      = "tableCell"
    fileprivate var collectionViewCellIdentifier = "collectionCell"
    
    //CollectionView Variables
    fileprivate var itemsPerRow     : CGFloat   = 3 // Collection View Number Of Grid In Single Row
    fileprivate let sectionInsets   = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 8.0, right: 8.0)    // Collection View Grid Padding
    
    fileprivate var selectedCell                : ContentCollectionViewCell?
    fileprivate var lastSelectedIndexPath       : IndexPath? = nil
    fileprivate var lastSelectedRow             : Int        = 0
    fileprivate var currentAnimationTransition  : UIViewControllerAnimatedTransitioning? = nil
    
    fileprivate var selectedNode                : [Node]?
    private var selectedFrame                   : CGRect?
    
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
        
        //Setting up the tableView
        setupTableView()
    }
    
    /*
      - This method will load the json from the file
    */
    func loadJson(){
        contentModel = Utility.readJSONFromFile(fileName: Constants.jsonFileName)
    }
    
    /*
        - Setting up the tableView
     */
    func setupTableView(){
        tableView.separatorStyle = .none
    }
    
    //Navigate to the PlayerView Controller method
    func navigateToPlayerScreen(categoryIndex : Int, selectedVideoIndex : Int){
        
        let mainStoryboard = UIStoryboard(name: Constants.mainStoryboard, bundle: Bundle.main)
        let vc : PageViewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.pageViewControllerScreen) as! PageViewController
        
        //Setting the transition delegate since we want to perform navigation like photos app
        //vc.transitioningDelegate = self

        //navigationController?.transitioningDelegate = self
        
        //Passing this data to DetailViewController
        //vc.videoUrl = contentModel?[categoryIndex].nodes?[selectedVideoIndex].video?.encodeURL ?? ""
        vc.nodes                = contentModel?[categoryIndex].nodes
        vc.selectedVideoIndex   = selectedVideoIndex
        
        navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true, completion: nil)
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
        cell.setupCollectionCell(content: contentModel?[collectionView.tag].nodes?[indexPath.item], atIndex: indexPath.item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Video Position \(indexPath.item)")
        
        selectedCell            = collectionView.cellForItem(at: indexPath) as? ContentCollectionViewCell
        selectedNode            = contentModel?[collectionView.tag].nodes
        
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame           = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        
        lastSelectedIndexPath   = indexPath
        lastSelectedRow         = collectionView.tag
        
        navigateToPlayerScreen(categoryIndex: collectionView.tag, selectedVideoIndex: indexPath.item)
        
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

/*
//MARK|:- Transition Delegate Methods
extension ViewController : PhotoDetailTransitionAnimatorDelegate{
    
    func transitionWillStart() {
        guard let lastSelected = self.lastSelectedIndexPath else { return }
        if let cell = tableView.cellForRow(at: IndexPath(row: lastSelectedRow, section: 0)) as? ViewControllerTableViewCell{
            cell.collectionView.cellForItem(at: lastSelected)?.isHidden = true
        }
    }

    func transitionDidEnd() {
        guard let lastSelected = self.lastSelectedIndexPath else { return }
        if let cell = tableView.cellForRow(at: IndexPath(row: lastSelectedRow, section: 0)) as? ViewControllerTableViewCell{
            cell.collectionView.cellForItem(at: lastSelected)?.isHidden = false
        }
        
    }

    func referenceImage() -> UIImage? {
        guard let lastSelected = self.lastSelectedIndexPath else { return nil }
        guard let cell = tableView.cellForRow(at: IndexPath(row: lastSelectedRow, section: 0)) as? ViewControllerTableViewCell else { return nil }
        guard let collectionViewCell = cell.collectionView.cellForItem(at: lastSelected) as? ContentCollectionViewCell else { return nil }
        
        return collectionViewCell.thumbImageView.image
    }

    func imageFrame() -> CGRect? {
        guard let lastSelected = self.lastSelectedIndexPath,
        let cell = tableView.cellForRow(at: IndexPath(row: lastSelectedRow, section: 0)) as? ViewControllerTableViewCell
        else {
            return nil
        }

        return cell.collectionView.convert(cell.frame, to: self.view)
    }
}

extension ViewController : UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        
        let result: UIViewControllerAnimatedTransitioning?
        if let photoDetailVC = toVC as? PageViewController,
            operation == .push
        {
            result = PhotoDetailPushTransition(fromDelegate: fromVC, toPhotoDetailVC: photoDetailVC)
        }
//        else if
//            let photoDetailVC = fromVC as? PageViewController,
//            operation == .pop
//        {
//
////            if photoDetailVC.isInteractivelyDismissing {
////                result = PhotoDetailInteractiveDismissTransition(fromDelegate: photoDetailVC, toDelegate: toVC)
////            } else {
////                result = PhotoDetailPopTransition(toDelegate: toVC, fromPhotoDetailVC: photoDetailVC)
////            }
//        }
        else {
            result = nil
        }
        self.currentAnimationTransition = result
        return result
        
    }
    
    public func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return self.currentAnimationTransition as? UIViewControllerInteractiveTransitioning
    }

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        self.currentAnimationTransition = nil
    }
}
*/
