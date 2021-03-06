//
//  RequestTableViewCell.swift
//  xeem-service-app
//
//  Created by Anh-Tu Hoang on 12/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var model: Request! {
        didSet{
            nameLabel.text = "Ken Hoang"
            timeLabel.text = "1 seconds ago"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
