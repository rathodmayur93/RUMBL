//
//  PlayerViewController.swift
//  RUMBL
//
//  Created by ds-mayur on 12/10/19.
//  Copyright © 2019 Mayur Rathod. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController {

    //MARK:- IBOutlet Properties
    @IBOutlet var customPlayerView          : UIView!
    @IBOutlet weak var progressIndicator    : UIActivityIndicatorView!
    
    //Custom Player Views
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    //MARK:- Variables
    fileprivate var isPlaying = true
    
    //Getting the values from previous ViewCOntroller i.e ViewController or Explore Screen
    public var videoUrl  : String = ""
    public var itemIndex : Int    = 0
    
    // Key-value observing context
    private var playerItemContext = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the UI
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Player Will Appear")
        
        //Hide navigation bar since we want to show the video on entire screen
        hideNavigationbar()
        // If video is pause then play the video as soon as video appears to the user
        player?.play()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(("Observer removed"))
        player?.pause()
        //removingObserver()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        //player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    //MARK:- UI Related Methods
    func setUI(){
        
        //Setting up the player
        setupPlayer()
        
        //Setting up the tap gesture
        setupTapGesture()
        
        //Adding the observers
        addingObservers()
        
        //Hide the play button
        playButton.isHidden = true
        
        //Setting the activity indicator
        progressIndicator.hidesWhenStopped = true
        
        //Animating the progress bar
        //progressIndicator.startAnimating()
    }
    
    
    //Adding the observers
    func addingObservers(){
        /*
            - This observer will be triggered when app move to the background
         */
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(customPlayerTapAction),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    //Hide navigation bar
    func hideNavigationbar(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //Setting up the Tap Gesture
    func setupTapGesture(){
        
        //Setting up the tap gesture on the customPlayerView to play & pause the video
        let playerTapGesture = UITapGestureRecognizer(target: self, action: #selector(customPlayerTapAction))
        playerTapGesture.numberOfTouchesRequired = 1
        customPlayerView.isUserInteractionEnabled = true
        customPlayerView.addGestureRecognizer(playerTapGesture)
    }
    
    //Setting up the AVPlayer
    func setupPlayer(){
        
        print("Observer Added")
        
        let url                         = URL(string: videoUrl)!   // Playing the video from this URL
        let videoAsset                  = AVURLAsset(url: url, options: nil) //Converting URL into the AVURLAsset
        let playerItem                  = AVPlayerItem(asset: videoAsset) // Creating AVPlayerItem from videoAsset
        
        // Register as an observer of the player item's status property
        //playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        
        player  = AVPlayer(playerItem: playerItem) // Passing playerItem to AVPlayer to play video
        player?.play()
        
        //addingObservers()
        //Adding observer to the player which will tell us whether loading is done or not
//        handlePlayerBuffer()
//        player?.currentItem?.addObserver(self, forKeyPath: Constants.isBufferEmpty, options: .new, context: nil)
//        player?.currentItem?.addObserver(self, forKeyPath: Constants.playBackLikelyToKeepItUp, options: .new, context: nil)
//        player?.currentItem?.addObserver(self, forKeyPath: Constants.playBackBufferFull, options: .new, context: nil)
//        player?.addObserver(self, forKeyPath: Constants.loadPlayerObserver, options: .new, context: nil)
        
        if let isPlayBackBufferEmpty = self.player?.currentItem?.isPlaybackBufferEmpty{
            if isPlayBackBufferEmpty{
                self.progressIndicator.isHidden = false
            }
        }
        
        if self.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay{
            if let isPlaybackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp {
                if isPlaybackLikelyToKeepUp{
                    self.progressIndicator.stopAnimating()
                    self.progressIndicator.isHidden = true
                }
            }
        }
        
        self.showsPlaybackControls = false                      // Do not show default controller
        self.contentOverlayView?.addSubview(customPlayerView)   // Adding custom player layer to AVPlayer
    }
    
    //Adding the observer
    func addingObserver(){
        /*
            - We will add the observer since we want to receive any events
        */
        player?.currentItem?.addObserver(self, forKeyPath: Constants.isBufferEmpty, options: .new, context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: Constants.playBackLikelyToKeepItUp, options: .new, context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: Constants.playBackBufferFull, options: .new, context: nil)
    }
    
    //Removing the observer
    func removingObserver(){
        /*
            - We will remove the observer since we dont want to receive any events
         */
        //NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        //player?.removeObserver(self, forKeyPath: Constants.loadPlayerObserver)
        
        player?.currentItem?.removeObserver(self, forKeyPath: Constants.isBufferEmpty)
        player?.currentItem?.removeObserver(self, forKeyPath: Constants.playBackLikelyToKeepItUp)
        player?.currentItem?.removeObserver(self, forKeyPath: Constants.playBackBufferFull)
    }
    
    //Handling the player buffer
    func handlePlayerBuffer(){
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(playerStalled(_:)),
                                               name: NSNotification.Name.AVPlayerItemPlaybackStalled,
                                               object: self.player?.currentItem)

        /*
        //When buffer is empty show the progress indicator
        if let isPlayBackBufferEmpty = self.player?.currentItem?.isPlaybackBufferEmpty{
            if isPlayBackBufferEmpty{
                self.progressIndicator.isHidden = false
                self.progressIndicator.startAnimating()
            }
        }
        
        if self.player?.currentItem?.status == AVPlayerItem.Status.readyToPlay{
            if let isPlaybackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp {
                if isPlaybackLikelyToKeepUp{
                    self.progressIndicator.stopAnimating()
                }
            }
        }
         */

    }
    
    //When player is stalled show the loader
    @objc func playerStalled(_ notification: Notification){
        self.progressIndicator.isHidden = false
        self.progressIndicator.startAnimating()
    }
    
    //MARK:- IBAction Methods
    @IBAction func backButtonAction(_ sender: Any) {
        
        //player?.currentItem?.removeObserver(self, forKeyPath:  #keyPath(AVPlayerItem.status))
        //Dismissing the view controller
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        customPlayerTapAction()
    }
    
    //MARK: Tap Action Methods
    @objc func customPlayerTapAction(){
        
        /*
          -  If condition will check whether player is playing the video or not
          - If video is playing then will pause the video
          = Else will play the video
          - Will update the visibillity status of the play button on customPlayerView
         */
        if isPlaying{
            player?.pause()
            isPlaying.toggle()
        }else{
            player?.play()
            isPlaying.toggle()
        }
        
        //Update the play button visibility status
        playButton.isHidden = isPlaying
        
    }
}
