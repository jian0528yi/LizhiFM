//
//  ContainerCell.swift
//  LizhiFM
//
//  Created by JLB on 2016/11/24.
//  Copyright © 2016年 LB. All rights reserved.
//

import UIKit
import Kingfisher

class ContainerCell: UITableViewCell {

    var container: Container? {
        didSet {
            self.title.text = container?.title
            let url = URL(string: (container?.albumArtURI)!)
            self.icon.kf.setImage(with: url)
        }
    }

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
