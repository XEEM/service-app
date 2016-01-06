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
import DateTools

class RequestTableViewCell: MGSwipeTableCell  {

    var indexPath: NSIndexPath!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var model: Request! {
        didSet{
            nameLabel.text = model.transportation.name
//            let type: String = model.dictionary.objectForKey("Type") as? String
            typeLabel.text = model.text

            timeLabel.text = "\(Helper.dateDistanceStringFromNow(model.createdDate)) ago"
//            let timeAgoDate = model.createdDate
//            if let timeAgoDate = timeAgoDate {
//                timeLabel.text = timeAgoDate.timeAgoSinceNow()
//            } else {
//                timeLabel.text = "--"
//            }

            userAvatarImage.setImageWithURL(NSURL(string: model.transportation.imageUrls[0])!, placeholderImage: UIImage(named: "image-placeholder"))
//            switch model.transportation.type {
//                case
//            }
        }
    }
    
    
    func setLayout() {
        self.leftButtons = [MGSwipeButton(title: "Accept", backgroundColor: UIColor.greenColor())]
        self.leftExpansion.fillOnTrigger = true
        self.leftExpansion.buttonIndex = 0
        self.leftSwipeSettings.transition = MGSwipeTransition.Drag
        //configure right buttons
        self.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor())
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor())]
        self.rightSwipeSettings.transition = MGSwipeTransition.Static
    }
}

