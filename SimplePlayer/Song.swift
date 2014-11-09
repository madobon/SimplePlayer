//
//  Song.swift
//  SimplePlayer
//
//  Created by madobon on 2014/11/01.
//  Copyright (c) 2014年 madobon. All rights reserved.
//

import UIKit

/**
 * 曲情報クラス
 */
class Song {
    
    /** アルバムアート */
    var albumArt: UIImage?
    
    /** アルバム名 */
    var albumName: String
    
    /** アーティスト名 */
    var artistName: String
    
    /** 曲名 */
    var songName: String
    
    /** 曲ID */
    var songId: NSNumber
    
    /** 曲URL */
    // 以下、nilパターン
    // 昔、iTunesで購入したDRM付きの曲。
    // iCloudにあって、iPhoneにダウンロードされていない曲。
    var songUrl: NSURL?
    
    /** 曲の長さ */
    var songDuration: NSNumber
    
    /**
     * デフォルトコンストラクタ（初期化）
     */
    init() {
        self.albumArt = nil
        self.albumName = ""
        self.artistName = ""
        self.songId = 0
        self.songName = ""
        self.songDuration = 0
        self.songUrl = nil
    }
    
    /**
     * デフォルトコンストラクタ（初期値設定）
     */
    init(albumArt:UIImage?, albumName:String, artistName:String, songId:NSNumber, songName:String, songDuration: NSNumber, songUrl:NSURL?){
        self.albumArt = albumArt
        self.albumName = albumName
        self.artistName = artistName
        self.songId = songId
        self.songName = songName
        self.songDuration = songDuration
        self.songUrl = songUrl

    }
}