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
    @IBOutlet var customPlayerView: UIView!
    
    //Custom Player Views
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    //MARK:- Variables
    fileprivate var isPlaying = true
    
    //Getting the values from previous ViewCOntroller i.e ViewController or Explore Screen
    public var videoUrl  : String = ""
    public var itemIndex : Int    = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the UI
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationbar()
        print("Player Will Appear")
        
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("PLayer Got Disappear")
        player?.pause()
    }
    
    //MARK:- UI Related Methods
    func setUI(){
        
        //Setting up the player
        setupPlayer()
        
        //Setting up the tap gesture
        setupTapGesture()
        
        //Hide the play button
        playButton.isHidden = true
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
        let url                         = URL(string: videoUrl)!   // Playing the video from this URL
        let videoAsset                  = AVURLAsset(url: url, options: nil) //Converting URL into the AVURLAsset
        let playerItem                  = AVPlayerItem(asset: videoAsset) // Creating AVPlayerItem from videoAsset
        player                          = AVPlayer(playerItem: playerItem) // Passing playerItem to AVPlayer to play video
        player?.play()
        
        self.showsPlaybackControls = false                      // Do not show default controller
        self.contentOverlayView?.addSubview(customPlayerView)   // Adding custom player layer to AVPlayer
    }
    
    //MARK:- IBAction Methods
    @IBAction func backButtonAction(_ sender: Any) {
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

extension PlayerViewController: PhotoDetailTransitionAnimatorDelegate {
    func transitionWillStart() {
        self.view.isHidden = true
    }

    func transitionDidEnd() {
        self.view.isHidden = false
    }

    func referenceImage() -> UIImage? {
        return UIImage(named: "noImageList")
    }

    func imageFrame() -> CGRect? {
        let rect = CGRect.makeRect(aspectRatio: view.frame.size, insideRect: view.bounds)
        return rect
    }
}
