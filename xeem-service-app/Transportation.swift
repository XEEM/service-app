//
//  Transportation.swift
//  XEEM
//
//  Created by Giao Tuan on 12/12/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import Foundation

enum TransportationType: String  {
    case Bike = "B"
    case Car = "C"
    case Scooter = "S"
    case Motorbike = "M"
}

class Transportation: NSObject {
    var id : String!
    var name : String!
    var dictionary: NSDictionary
    var type: TransportationType!
    var imageUrls: [String]!
    var requests: [Request]!
    
    init(dictionary : NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["Id"] as? String
        name = dictionary["Name"] as? String
        type = TransportationType(rawValue: dictionary["Type"] as! String)
        imageUrls = dictionary["ImageUrls"] as? [String]
        
        requests = Request.initWithArray(dictionary["Requests"] as! [NSDictionary])
    }
    
    class func TransWithArray(array: [NSDictionary]) -> [Transportation] {
        var trans = [Transportation]()
        for dict in array {
            trans.append(Transportation(dictionary: dict))
        }
        return trans
    }
}
