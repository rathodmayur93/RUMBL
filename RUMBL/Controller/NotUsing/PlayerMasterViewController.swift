//
//  PlayerMasterViewController.swift
//  RUMBL
//
//  Created by ds-mayur on 12/12/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerMasterViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    fileprivate let cellName = "playerCell"
    
    //Getting the values from previous ViewCOntroller i.e ViewController or Explore Screen
    var nodes               : [Node]?
    var selectedVideoIndex  : Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the UI Elements
        setUI()
    }
    
    //Setting up the UI element
    func setUI(){
        
        //Setting up the tableView
        setupTableView()
        
        //Hide navigation bar
        hideNavigationbar()
    }
    
    //Hide navigation bar
    func hideNavigationbar(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //Setting up the tableView
    func setupTableView(){
        tableView.isPagingEnabled = true
        tableView.backgroundColor = UIColor.black
        tableView.register(UINib(nibName: "PlayerMasterTableViewCell", bundle: nil), forCellReuseIdentifier: cellName)
    }

}

extension PlayerMasterViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as? PlayerMasterTableViewCell else { return UITableViewCell() }
        
        let url         = URL(string: nodes?[indexPath.row].video?.encodeURL ?? "")
        let avPlayer    = AVPlayer(url: url!)
        cell.playerView.playerLayer.player = avPlayer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height
    }
}

extension PlayerMasterViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? PlayerMasterTableViewCell else { return }
        
        let visibleCells    = tableView.visibleCells
        let minIndex        = visibleCells.startIndex
        if tableView.visibleCells.firstIndex(of: cell) == minIndex {
            cell.playerView.player?.play()
            print("PLay Video")
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        guard let cell = cell as? PlayerMasterTableViewCell else { return }
        
        cell.playerView.player?.pause();
        cell.playerView.player = nil;
    }
}
