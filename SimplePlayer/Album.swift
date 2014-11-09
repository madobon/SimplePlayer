//
//  Album.swift
//  SimplePlayer
//
//  Created by madobon on 2014/11/01.
//  Copyright (c) 2014年 madobon. All rights reserved.
//

/**
 * アルバム情報クラス
 */
class Album  {
    
    /** 曲情報（配列） */
    var songs: [Song]
    
    /**
     * デフォルトコンストラクタ（初期化）
     */
    init() {
        self.songs = [Song()]
    }
    
    /**
     * デフォルトコンストラクタ（初期値設定）
     */
    init(songs: [Song]) {
        self.songs = songs
    }
}
