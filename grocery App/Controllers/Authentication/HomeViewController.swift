//
//  HomeViewController.swift
//  grocery App
//
//  Created by Wa ibra. on 05/04/1443 AH.
//

import UIKit
import AVKit

class HomeViewController: UIViewController {

    //variables
    var videoPlayer : AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    var playerLooper: AVPlayerLooper?

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setup video in background
        setUpVideo()
    }
    
    func setUpElements(){
          
        //style the elements
        Utilities.styleFilledButton(signupButton)
        Utilities.styleHollowButton(loginButton)

    }
    
    //Setting Up a Video
    func setUpVideo()
    {
        //get the path to the resource in the bundle
        let bundlePath =  Bundle.main.path(forResource: "video", ofType: "mp4")
        guard bundlePath != nil else{
            return
        }
        //create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)


        //create video player item
        let item = AVPlayerItem(url: url)


        //create the player
       let videoPlayer = AVQueuePlayer(playerItem: item)

        //create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)

        //adjust size and frame

        videoPlayerLayer?.frame = CGRect(x: -56, y: 0,
                                         width:self.view.frame.size.width*1.3,
                                         height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)

        //video loop
        playerLooper = AVPlayerLooper(player: videoPlayer, templateItem: item)

        //Add it to the view and play it
        videoPlayer.playImmediately(atRate: 0.5)
    }

}
