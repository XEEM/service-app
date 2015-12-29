//
//  Quotes.swift
//  XEEM
//
//  Created by Le Thanh Tan on 12/19/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import UIKit

class Quotes: NSObject {

    var id: Int?
    var name: String?
    var price: Int64?
    
    init(dictionary: NSDictionary) {

        self.id = dictionary.objectForKey("Id") as? Int
        self.name = dictionary.objectForKey("Name") as? String
        self.price = dictionary.objectForKey("Price") as? Int64
    }
    
    class func initWithArray(array: [NSDictionary]) -> [Quotes] {
        var arrQuotes = [Quotes]()
        for dic in array {
            arrQuotes.append(Quotes.init(dictionary: dic))
        }
        return arrQuotes
    }
    
}
