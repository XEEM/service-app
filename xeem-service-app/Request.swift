//
//  Request.swift
//  XEEM
//
//  Created by Anh-Tu Hoang on 12/28/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import Foundation
import SwiftDate

enum RequestStatus: String  {
    case Accepted = "A"
    case Waiting = "W"
    case Finished = "F"
}

class Request: NSObject {
    var id : String!
    var createdDate : NSDate!
    var dictionary: NSDictionary
    var status: RequestStatus!
    var shopId: String!
    var transportation: Transportation!
    var latitude: Double?
    var longitude: Double?
    var text: String?
    
    init(dictionary : NSDictionary) {
        self.dictionary = dictionary
        id = String(dictionary["Id"]!)
        shopId = String(dictionary["RepairShopId"]!)
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        text = String(dictionary["description"])
        
        createdDate = (dictionary["CreatedDate"] as! String).toDate(DateFormat.Custom("yyyy-MM-dd'T'hh:mm:ss"))
        status = RequestStatus(rawValue: dictionary["Status"] as! String)
        
        if let dict = dictionary["Transportation"] as? NSDictionary {
            transportation = Transportation(dictionary: dict)
        }
    }
    
    class func initWithArray(array: [NSDictionary]) -> [Request] {
        var requests = [Request]()
        for dict in array {
            requests.append(Request(dictionary: dict))
        }
        return requests
    }
}
