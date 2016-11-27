//
//  TrackMetadata.swift
//  LizhiFM
//
//  Created by JLB on 2016/11/26.
//  Copyright © 2016年 LB. All rights reserved.
//

import UIKit

class TrackMetadata: NSObject {

    /*
     <artist>笑不出来</artist>
     <duration>629</duration>
     <albumArtURI>http://cdn.lizhi.fm/audio_cover/2016/08/11/30586674581134087_320x320.jpg</albumArtURI>
     <canPlay>true</canPlay>
     <canSkip>true</canSkip>
     <canAddToFavorites>false</canAddToFavorites>
     */

    var artist: String?
    var duration: String?
    var albumArtURI: String?
    var canPlay: String?
    var canSkip: String?
    var canAddToFavorites: String?

}
