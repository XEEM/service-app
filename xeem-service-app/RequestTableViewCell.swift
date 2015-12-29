//
//  RequestTableViewCell.swift
//  xeem-service-app
//
//  Created by Anh-Tu Hoang on 12/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import AFNetworking
import MGSwipeTableCell

class RequestTableViewCell: MGSwipeTableCell  {

    var indexPath: NSIndexPath!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var model: Request! {
        didSet{
            nameLabel.text = model.transportation.name
            timeLabel.text = model.createdDate.toString()
            userAvatarImage.setImageWithURL(NSURL(string: (model?.transportation.imageUrls[0])!)!)
        }
    }
}

