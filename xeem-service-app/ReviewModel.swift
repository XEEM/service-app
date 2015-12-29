//
//  ReviewModel.swift
//  XEEM
//
//  Created by Le Thanh Tan on 12/19/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import UIKit

class ReviewModel: NSObject {

    var rating: Float?
    var descriptions: String?
    var reviewer: User?
    var dateCreated : NSDate?
    
    init(dictionary: NSDictionary) {
        self.rating = dictionary.objectForKey("Rating") as? Float
        self.descriptions = dictionary.objectForKey("Description") as? String
        self.reviewer = User.init(dictionary: dictionary.objectForKey("Reviewer") as? NSDictionary)
        let dateInString = dictionary.objectForKey("CreatedDate") as? String
        if let dateInString = dateInString {
            dateCreated = NSDate(dateString: dateInString)
        } 
    }
    
    class func initWithArray(array: [NSDictionary]) -> [ReviewModel] {
        var arrReviewModel = [ReviewModel]()
        for dic in array {
            arrReviewModel.append(ReviewModel.init(dictionary: dic))
        }        
        return arrReviewModel
    }
}
extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateStringFormatter.timeZone = NSTimeZone(name: "UTC")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}
