//
//  Constants.swift
//  RUMBL
//
//  Created by ds-mayur on 12/9/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import Foundation

struct Constants {
    
    static let jsonFileName         = "assignment"
    static let exploreScreenTitle   = "Explore"
    
    
    //Storyboard names
    static let mainStoryboard               = "Main"
    
    //ViewController Names
    static let exploreScreen                = "ViewController"
    static let pageViewControllerScreen     = "PageViewController"
    static let playerScreen                 = "PlayerViewController"
    static let mainPageViewController       = "MainPageViewController"
    static let masterPlayerViewController   = "PlayerMasterViewController"
    
    //Segue Name
    static let player                       = "Player"
    
    //Observers
    static let loadPlayerObserver           = "currentItem.loadedTimeRanges"
    static let isBufferEmpty                = "playbackBufferEmpty"
    static let playBackLikelyToKeepItUp     = "playbackLikelyToKeepUp"
    static let playBackBufferFull           = "playbackBufferFull"
}
