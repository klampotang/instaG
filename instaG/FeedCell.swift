//
//  FeedCell.swift
//  instaG
//
//  Created by Kelly Lampotang on 6/21/16.
//  Copyright © 2016 Kelly Lampotang. All rights reserved.
//

import UIKit
import ParseUI

class FeedCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var instaPostPic: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
