//
//  SongManager.swift
//  SimplePlayer
//
//  Created by madobon on 2014/06/06.
//  Copyright (c) 2014年 madobon. All rights reserved.
//

import MediaPlayer

/**
 * 音楽管理マネージャ
 */
class SongManager {
    
    /**
     * ミュージックライブラリの曲をアルバム毎に返却します。
     */
    func getAll() -> [Album] {
        
        // 格納用
        var albums: [Album] = []
        
        // アルバム情報から曲を取り出す
        var albumsQuery: MPMediaQuery = MPMediaQuery.albumsQuery()
        var albumItems: [MPMediaItemCollection] = albumsQuery.collections as [MPMediaItemCollection]
        
        // アルバム単位に曲情報を追加
        for albumItem in albumItems {
            
            // アルバム単位の曲情報（配列）
            var songs: [Song] = []
            
            var album:[MPMediaItem] = albumItem.items as [MPMediaItem]
            
            for song in album {
                
                songs.append(
                    Song(
//                        albumArt:       song.valueForProperty( MPMediaItemPropertyArtwork ) as? UIImage,
                        albumArt:       UIImage(),
                        albumName:      song.valueForProperty( MPMediaItemPropertyAlbumTitle ) as String,
                        artistName:     song.valueForProperty( MPMediaItemPropertyArtist ) as String,
                        songId:         song.valueForProperty( MPMediaItemPropertyPersistentID ) as NSNumber,
                        songName:       song.valueForProperty( MPMediaItemPropertyTitle ) as String,
                        songDuration:   song.valueForProperty( MPMediaItemPropertyPlaybackDuration ) as NSNumber,
                        songUrl:        song.valueForProperty( MPMediaItemPropertyAssetURL ) as? NSURL
                    )
                )
            }
            
            albums.append(Album(songs:songs))
        }
        
        return albums
        
    }
    
    /**
     * 曲IDから曲情報(MPMediaItem)を取得する
     */
    func getItem( songId: NSNumber ) -> MPMediaItem {

        // 検索条件
        var property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )
        
        // フィルターを設定
        var query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )
        
        var items: [MPMediaItem] = query.items as [MPMediaItem]
        
        return items[items.count - 1]
        
    }
    
}
