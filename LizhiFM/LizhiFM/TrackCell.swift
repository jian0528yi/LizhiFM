//
//  TrackCell.swift
//  LizhiFM
//
//  Created by JLB on 2016/11/26.
//  Copyright © 2016年 LB. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {

    var track: Track? {
        didSet {
            let url = URL(string: (track?.trackMetadata?.albumArtURI)!)
            self.icon.kf.setImage(with: url)
            self.title.text = track?.title
            self.artist.text = track?.trackMetadata?.artist
        }
    }

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
