//
//  ViewController.swift
//  SimplePlayer
//
//  Created by madobon on 2014/11/06.
//  Copyright (c) 2014年 madobon. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate {

    
    /** アルバム（配列） */
    var albums = [Album()]

    /** 再生曲 */
    var nowPlayingSong = Song()
    
    /** 再生曲の行 */
    var nowPlayingIndexPath = NSIndexPath()
    
    /** 曲情報管理マネージャ */
    var songManager = SongManager()
    
    var eventSubType: UIEventSubtype?
    
    var audio: AVAudioPlayer! = nil

    /** Outlet: テーブルビュー */
    @IBOutlet private weak var tableView: UITableView!
    
    /** Outlet: スライダー */
    @IBOutlet private weak var slider: UISlider!
    
    /** Action: スライド */
    @IBAction func doSlide(sender: UISlider) {
        audio.volume = slider.value
    }
    
    /** Action: 停止 */
    @IBAction func doStop(sender: UIBarButtonItem) {
        stopAudio()
    }
    
    /** Action: 再生/一時停止 */
    @IBAction func doPlayPause(sender: UIBarButtonItem) {
        
        toggleAudio()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // タイトルの設定
        self.title = "音楽"
        
        
        // アルバム（配列）
        albums = songManager.getAll()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    /**
    * sectionの数を返す
    */
    func numberOfSectionsInTableView( tableView: UITableView! ) -> Int {
        // アルバム数を設定する
        return albums.count
    }
    
    
    /**
    * 各sectionのitem数を返す
    */
    func tableView( tableView: UITableView!, numberOfRowsInSection section: Int ) -> Int  {
        // アルバムごとの曲数を設定する
        return albums[section].songs.count
    }
    
    func tableView( tableView: UITableView?, cellForRowAtIndexPath indexPath:NSIndexPath! ) -> UITableViewCell! {
        
        let cell: UITableViewCell = UITableViewCell( style: UITableViewCellStyle.Subtitle, reuseIdentifier: "musics" )
        
        var song = albums[indexPath.section].songs[indexPath.row]
        
        cell.textLabel.text = "\(song.songName) [\(song.songDuration)]"
        cell.detailTextLabel!.text = song.artistName
        cell.imageView.image = song.albumArt
        
        return cell;
    }
    
    // sectionのタイトル
    func tableView( tableView: UITableView?, titleForHeaderInSection section: Int ) -> String {
        
        return albums[section].songs[0].albumName
    }
    
    // 選択した音楽を再生
    func tableView( tableView: UITableView?, didSelectRowAtIndexPath indexPath:NSIndexPath! ) {
        
        nowPlayingIndexPath = indexPath
        
        // 再生中の曲
        nowPlayingSong = albums[nowPlayingIndexPath.section].songs[nowPlayingIndexPath.row]
        
        // セットアップ
        setupAVAudioPlayer()
        
        // 再生
        playAudio()
        
        
    }
    
    func toggleAudio() {
        
        if audio == nil {
            return
        }
        

        
        if audio.playing {

            pauseAudio()

        } else {
            playAudio()
        }
        
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        
        // イベント取得
        eventSubType = event.subtype
        
        switch eventSubType! {
        case .RemoteControlTogglePlayPause,
             .RemoteControlPlay,
             .RemoteControlPause:
            // 再生・一時停止
            toggleAudio()
            break
        case .RemoteControlPreviousTrack:
            // 前
            previousAudio()
            break
        case .RemoteControlNextTrack:
            // 次
            nextAudio()
            break
        default:
            break
        }
    }
    
    func setupAVAudioPlayer() {
        
        audio = AVAudioPlayer(contentsOfURL: nowPlayingSong.songUrl, error: nil)
        
        audio.volume = slider.value
        
    }
    
    func playAudio() {
        
        if audio == nil {
            return
        }
        
        // 音楽の再生
        audio.play()
        
        // コントロールセンター
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyTitle : nowPlayingSong.songName,
            MPMediaItemPropertyArtist : nowPlayingSong.artistName,
            //            MPMediaItemPropertyArtwork : nowPlayingSong.albumArt,
            MPNowPlayingInfoPropertyPlaybackRate : 1.0
        ]
        
        // タイトル設定
        self.navigationItem.title = nowPlayingSong.songName
        
        var buttons = [UIBarButtonItem()]
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "previousAudio"))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: "toggleAudio"))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "nextAudio"))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        
        self.setToolbarItems(buttons, animated: false)

    }
    
    func stopAudio() {
        if audio == nil {
            return
        }
        
        audio.stop()
    }
    
    func pauseAudio() {
        
        if audio == nil {
            return
        }
        
        // 音楽の停止
        audio.pause()
        
        var buttons = [UIBarButtonItem()]
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "previousAudio"))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "toggleAudio"))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "nextAudio"))
        buttons.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        
        self.setToolbarItems(buttons, animated: false)
    }
    
    /**
     * 前の曲
     */
    func previousAudio() {
        if nowPlayingIndexPath.row - 1 < 0 {
            // 前のアルバム
            
            if nowPlayingIndexPath.section - 1 < 0 {
                // 最初のアルバム TODO: 最後のアルバムの最後の曲にする？
                nowPlayingIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            } else {
                nowPlayingIndexPath = NSIndexPath(forRow: albums[nowPlayingIndexPath.section - 1].songs.count - 1, inSection: nowPlayingIndexPath.section - 1)
            }
            
        } else {
            // 前の曲
            nowPlayingIndexPath = NSIndexPath(forRow: nowPlayingIndexPath.row - 1, inSection: nowPlayingIndexPath.section)
        }
        
        nowPlayingSong = albums[nowPlayingIndexPath.section].songs[nowPlayingIndexPath.row]
        
        
        self.tableView.selectRowAtIndexPath(nowPlayingIndexPath, animated: true, scrollPosition: .Middle)
        
        // セットアップ
        setupAVAudioPlayer()
        
        // 再生
        playAudio()
    }
    
    /**
     * 次の曲
     */
    func nextAudio() {
        
        if nowPlayingIndexPath.row + 1 > albums[nowPlayingIndexPath.section].songs.count - 1 {
            // 次のアルバム
            
            if nowPlayingIndexPath.section + 1 > albums.count - 1 {
                // 最初のアルバム
                nowPlayingIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            } else {
                nowPlayingIndexPath = NSIndexPath(forRow: 0, inSection: nowPlayingIndexPath.section + 1)
            }
            
        } else {
            // 次の曲
            nowPlayingIndexPath = NSIndexPath(forRow: nowPlayingIndexPath.row + 1, inSection: nowPlayingIndexPath.section)
        }
        
        nowPlayingSong = albums[nowPlayingIndexPath.section].songs[nowPlayingIndexPath.row]
        
        self.tableView.selectRowAtIndexPath(nowPlayingIndexPath, animated: true, scrollPosition: .Middle)
        
        // セットアップ
        setupAVAudioPlayer()
        
        // 再生
        playAudio()
    }
    
}

