//
//  PageViewController.swift
//  RUMBL
//
//  Created by ds-mayur on 12/11/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    //MARK: Variables
    var pageViewController  : UIPageViewController?
    var pendingIndex        : Int?
    
    //Getting the values from previous ViewCOntroller i.e ViewController or Explore Screen
    var nodes               : [Node]?
    var selectedVideoIndex  : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
    }
    
    /*
        - Setting the status bar text colors to white since the whole screen will black while loading the video so to show the battery status and time we need to change the status bar style to lightContent
     */
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func createPageViewController() {
        let pageController = self.storyboard?.instantiateViewController(withIdentifier: Constants.mainPageViewController) as! UIPageViewController
        
        pageController.dataSource    = self
        pageController.delegate      = self
        
        if nodes!.count > 0{
            let firstController = getContentViewController(withIndex: selectedVideoIndex)!
            //let secondController = getContentViewController(withIndex: 1)!
            let contentControllers = [firstController]
            pageController.setViewControllers(contentControllers, direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
            
        }
        
        pageViewController = pageController
        self.addChild(pageViewController!)
        self.view.insertSubview(pageViewController!.view, at: 0)
        pageViewController!.didMove(toParent: self)
        
    }
    
    //Setup Pagination Icons and count
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return nodes!.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func currentControllerIndex() -> Int{
        let pageItemController = self.currentConroller()
        
        if let controller = pageItemController as? PlayerViewController {
            return controller.itemIndex
        }
        return -1
    }
    
    func currentConroller() -> UIViewController?{
        if (self.pageViewController?.viewControllers?.count)! > 0{
            return self.pageViewController?.viewControllers![0]
        }
        
        return nil
    }
    
    func getContentViewController(withIndex index: Int) -> PlayerViewController? {
        if index < nodes!.count{
            let contentVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.playerScreen) as! PlayerViewController
            contentVC.videoUrl  = nodes?[index].video?.encodeURL ?? ""
            contentVC.itemIndex = index
            
            return contentVC
        }
        
        return nil
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let contentVC = viewController as! PlayerViewController
        
        if contentVC.itemIndex > 0 {
            print("Paginating to previous screen")
            return getContentViewController(withIndex: contentVC.itemIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let contentVC = viewController as! PlayerViewController
        if contentVC.itemIndex + 1 < nodes!.count {
            print("Paginating to next screen")
            return getContentViewController(withIndex: contentVC.itemIndex + 1)
        }
        
        return nil
    }
}
