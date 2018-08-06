//
//  ViewController.swift
//  DemoMusicPlayer
//
//  Created by SumitKumar on 20/07/18.
//  Copyright © 2018 SumitKumar. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    var arrAlbums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer?

    @IBOutlet weak var tblMusicList: UITableView!
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViewComponents()
    }
    //MARK: Design After StoryBoard
    func setupViewComponents() {
        
        fetchingAllAlbumListFromMusicLibrary()
    }

    func fetchingAllAlbumListFromMusicLibrary() {
        if #available(iOS 9.3, *) {
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.arrAlbums = self.songQuery.get(songCategory: "")
                    DispatchQueue.main.async {
                        self.tblMusicList?.rowHeight = UITableViewAutomaticDimension;
                        self.tblMusicList?.estimatedRowHeight = 60.0;
                        self.tblMusicList?.reloadData()
                    }
                } else {
                    self.displayMediaLibraryError()
                }
            }
        } else {
            // Fallback on earlier versions
        }

    }
    
    func displayMediaLibraryError() {
        
        var error: String
        if #available(iOS 9.3, *) {
            switch MPMediaLibrary.authorizationStatus() {
            case .restricted:
                error = "Media library access restricted by corporate or parental settings"
            case .denied:
                error = "Media library access denied by user"
            default:
                error = "Unknown error"
            }
        } else {
            // Fallback on earlier versions
        }
        
        let controller = UIAlertController(title: "Error", message: "Some Erorr occured", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }
    
    @objc func btnInfoAction() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let MusiqVC = storyBoard.instantiateViewController(withIdentifier: "MusiqVC") as! MusiqViewController
        navigationController?.pushViewController(MusiqVC, animated: true)
    }
    
    //MARK: Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let MusiqVC = storyBoard.instantiateViewController(withIdentifier: "MusiqVC") as! MusiqViewController
        navigationController?.pushViewController(MusiqVC, animated: true)

    }
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAlbums.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell") as! MusicTableViewCell

        let albumInfo = arrAlbums[indexPath.row]
        let songs = albumInfo.songs[0]
        print("\(songs.songTitle)")
        cell.lblName?.text = songs.songTitle
        cell.btnInfo.addTarget(self, action: #selector(btnInfoAction), for: .touchUpInside)
        return cell
    }
}
