//
//  MusiqViewController.swift
//  DemoMusicPlayer
//
//  Created by Sumit Kumar on 28/07/18.
//  Copyright © 2018 Sumit Kumar. All rights reserved.
//

import UIKit
import MediaPlayer

enum TrackStatus : Int {
    case STATUS_PLAY
    case STATUS_PAUSE
    case STATUS_STOP
}

class MusiqViewController: UIViewController, MPMediaPickerControllerDelegate {
    //MARK: IBOulets
    @IBOutlet weak var btnBegining: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPick: UIButton!
    @IBOutlet weak var constraintImgVwWidth: NSLayoutConstraint!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblComposerName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRemainIng: UILabel!
    @IBOutlet weak var lblElapsed: UILabel!
    @IBOutlet weak var viewTopContainer: UIView!
    @IBOutlet weak var imgVwAlbum: UIImageView!
    @IBOutlet weak var sliderTime: UISlider!
    
    //MARK: Variables
    let ROTATION_DURATION = 5.0
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    var timer = Timer()
    var mediapickerVC: MPMediaPickerController!
    var musicStatus  : TrackStatus!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupviewComponents()
    }
    //MARK: Design After StoryBoard
    func setupviewComponents() {
        musicPlayer.prepareToPlay()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
        
        self.timer.tolerance = 0.1
        
        //Declare media picker for later display
        let mediaPicker: MPMediaPickerController = MPMediaPickerController.self(mediaTypes:MPMediaType.music)
        mediaPicker.allowsPickingMultipleItems = true
        mediapickerVC = mediaPicker
        mediaPicker.delegate = self
        
        //make the album image circular
        imgVwAlbum.layer.cornerRadius = constraintImgVwWidth.constant/2
        //animateAlbumImage()
        musicStatus = .STATUS_STOP
    }
    
    func animateAlbumImage() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.byValue = 2.0 * .pi
        animation.duration = ROTATION_DURATION
        animation.repeatCount = Float.infinity
        imgVwAlbum.layer.add(animation, forKey: "indeterminateAnimation")
    }
    
    //Function to pull track info and update labels
    @objc func timerFired(_:AnyObject) {
        if let currentTrack = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem {
            //Track Length will return in total seconds
            let trackDuration = currentTrack.playbackDuration
            //We can get elapsed time from current play back time
            let trackElapsed = musicPlayer.currentPlaybackTime

            lblSongName.text = currentTrack.title
            lblArtistName.text = currentTrack.artist
            lblComposerName.text = currentTrack.composer
            
            //if song has no album image we need to set the default image
            imgVwAlbum.image = (currentTrack.artwork?.image(at: imgVwAlbum.frame.size) == nil) ? UIImage.init(named: "SongPlaceHolder") : currentTrack.artwork?.image(at: imgVwAlbum.frame.size)
            
            //set maximum value of the slider
            sliderTime.maximumValue = Float(trackDuration)
            
            //update the slider value according to progresses
            sliderTime.value = Float(trackElapsed)
            
            //playbackDuration Duration will give us in seconds so we need to convert it to minute
            let trackDurationMinutes = Int(trackDuration / 60)
            
            //Find the remainder from the previous equation. 245 / 60 is 4 with a remainder of 5. This results in 5
            let trackDurationSeconds = Int(Int(trackDuration)  % 60)
            
            if trackDurationSeconds < 10 {
                //add a 0 if the number of seconds is less than 10
                lblDuration.text = "L: \(trackDurationMinutes):0\(trackDurationSeconds)"                
            } else {
                //if more than 10, display as is
                lblDuration.text = "L: \(trackDurationMinutes):\(trackDurationSeconds)"
            }
            // avoid crash
            if trackElapsed.isNaN
            {
                return
            }
            
            //Repeat same steps to display the elapsed time as we did with the duration
            let trackElapsedMinutes = Int(trackElapsed / 60)
            
            //let trackElapsedSeconds = Int(trackElapsed % 60)
            let trackElapsedSeconds = Int(trackElapsed.truncatingRemainder(dividingBy: 60))
            
            if trackElapsedSeconds < 10 {
                lblElapsed.text = "E: \(trackElapsedMinutes):0\(trackElapsedSeconds)"
            } else {
                lblElapsed.text = "E: \(trackElapsedMinutes):\(trackElapsedSeconds)"
            }
            //Find remaining time by subtraction the elapsed time from the duration
            let trackRemaining = Int(trackDuration) - Int(trackElapsed)
            
            //Repeat same steps to display remaining time
            let trackRemainingMinutes = trackRemaining / 60
            
            let trackRemainingSeconds = trackRemaining % 60
            
            if trackRemainingSeconds < 10 {
                lblRemainIng.text = "R: \(trackRemainingMinutes):0\(trackRemainingSeconds)"
            } else {
                lblRemainIng.text = "R: \(trackRemainingMinutes):\(trackRemainingSeconds)"
            }
        }
    }

    //MARK: Button Actions
    @IBAction func btnPlayAction(_ sender: Any) {
        switch musicStatus {
        case .STATUS_STOP:
            musicPlayer.play()
            musicStatus = .STATUS_PLAY
            btnPlay.setImage(UIImage.init(named: "PauseIcon"), for: .normal)
            break
        case .STATUS_PLAY:
            btnPlay.setImage(UIImage.init(named: "ResumeIcon"), for: .normal)
            musicStatus = .STATUS_PAUSE
            musicPlayer.pause()
            break
        case .STATUS_PAUSE :
            musicPlayer.play()
            btnPlay.setImage(UIImage.init(named: "PauseIcon"), for: .normal)
            musicStatus = .STATUS_PLAY
            break
        default:
            break
        }
    }
    
    @IBAction func btnPreviousAction(_ sender: Any) {
        musicPlayer.skipToPreviousItem()
    }
    @IBAction func btnBeginingAction(_ sender: Any) {
        musicPlayer.skipToBeginning()
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        musicPlayer.skipToNextItem()
    }
    
    @IBAction func btnPickAction(_ sender: Any) {
        //open mediapicker VC
        present(mediapickerVC, animated: true, completion: nil)
    }
    
    @IBAction func timeSliderValuChanged(_ sender: Any) {
        musicPlayer.currentPlaybackTime = TimeInterval(sliderTime.value)
    }
    
    //MARK: Media Picker Controller Delegate Methods
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true, completion: nil)
        musicPlayer.setQueue(with: mediaItemCollection)
        
    }
    
    //MARK: Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
