//
//  Track.swift
//  LizhiFM
//
//  Created by JLB on 2016/11/26.
//  Copyright © 2016年 LB. All rights reserved.
//

import UIKit

class Track: NSObject {

    /*
     <id>ref:track:2550536056076499462</id>
     <itemType>track</itemType>
     <title>【神回复】长得丑是什么感受（首次回应主持人关系）</title>
     <mimeType>audio/mp3</mimeType>
     <trackMetadata>
     <artist>笑不出来</artist>
     <duration>629</duration>
     <albumArtURI>http://cdn.lizhi.fm/audio_cover/2016/08/11/30586674581134087_320x320.jpg</albumArtURI>
     <canPlay>true</canPlay>
     <canSkip>true</canSkip>
     <canAddToFavorites>false</canAddToFavorites>
     </trackMetadata>
     */

    var id: String?
    var itemType: String?
    var title: String?
    var mimeType: String?
    var trackMetadata: TrackMetadata?

}
