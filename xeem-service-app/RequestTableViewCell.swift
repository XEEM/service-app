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

protocol RequestTableViewCellDelegate {
    func requestTableViewCell(cell: RequestTableViewCell)
}

class RequestTableViewCell: MGSwipeTableCell  {

    var indexPath: NSIndexPath!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var delegate1: RequestTableViewCellDelegate!
    var timer: NSTimer!
    var model: Request! {
        didSet{
            nameLabel.text = model.transportation.name
//            let type: String = model.dictionary.objectForKey("Type") as? String
            typeLabel.text = model.text

//            timeLabel.text = "\(Helper.dateDistanceStringFromNow(model.createdDate))"
            timeLabel.text = "2:00"
//            let timeAgoDate = model.createdDate
//            if let timeAgoDate = timeAgoDate {
//                timeLabel.text = timeAgoDate.timeAgoSinceNow()
//            } else {
//                timeLabel.text = "--"
//            }

//            userAvatarImage.setImageWithURL(NSURL(string: model.transportation.imageUrls[0])!, placeholderImage: UIImage(named: "image-placeholder"))
            
            switch model.transportation.type! {
            case .Bike:
                userAvatarImage.image = UIImage(named: "ic_bike")
                break
            case .Car:
                userAvatarImage.image = UIImage(named: "ic_car")
                break
            case .Motorbike:
                userAvatarImage.image = UIImage(named: "ic_motorbike")
                break
            case .Scooter:
                userAvatarImage.image = UIImage(named: "ic_scooter")
                break
            }
            
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "updateTimeRemaining", userInfo: nil, repeats: true)
        }
    }
    
    let timeInterval: NSTimeInterval = 1.0
    var timeCount: NSTimeInterval = 2.0 * 60
    
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Double(minutes) * 60
        return String(format:"%02i:%02i",minutes,Int(seconds))
    }
    
    func updateTimeRemaining(){
        timeCount = timeCount - timeInterval
        if timeCount <= 0 {  //test for target time reached.
            print("end")
            self.delegate1.requestTableViewCell(self)
            timer.invalidate()
        } else { //update the time on the clock if not reached
            timeLabel.text = timeString(timeCount)
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

