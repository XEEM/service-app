//
//  ShopModel.swift
//  XEEM
//
//  Created by Le Thanh Tan on 12/19/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ShopModel: NSObject {
    
    var id: String?
    var name: String?
    var address: String?
    var phone: String?
    var isAvailable: Bool
    var latitude: Double?
    var longitde: Double?
    var avatarURL: String!
    var createdDate: String?
    var type: String?
    var owner: User?
    var reviews: [ReviewModel]?
    var quotes: [Quotes]?
    var rating: Float?
    var location : CLLocation?
    var distance : CLLocationDistance?
    var eta : String?
    var requests: [Request]?
    
    override init() {
        self.isAvailable = true
        super.init()

    }
    
    init(dictionary: NSDictionary) {
        self.id = dictionary.objectForKey("Id") as? String
        self.name = dictionary.objectForKey("Name") as? String
        self.address = dictionary.objectForKey("Address") as? String
        self.phone = dictionary.objectForKey("Phone") as? String
        self.isAvailable = (dictionary.objectForKey("IsAvailable") as? Bool)!
        self.latitude = Double((dictionary.objectForKey("Latitude") as? String)!)
        self.longitde = Double((dictionary.objectForKey("Longitude") as? String)!)
        self.location = CLLocation(latitude: self.latitude!, longitude: self.longitde!)
        //self.distance = currentLocation?.distanceFromLocation(self.location!)
        
        self.avatarURL = dictionary.objectForKey("AvatarUrl") as? String ?? ""
        self.createdDate = dictionary.objectForKey("CreatedDate") as? String
        self.type = dictionary.objectForKey("Type") as? String
        self.owner = User.init(dictionary: dictionary.objectForKey("Owner") as? NSDictionary)
        self.reviews = ReviewModel.initWithArray(dictionary.objectForKey("Reviews") as! [NSDictionary])
        self.quotes = Quotes.initWithArray(dictionary.objectForKey("Quotes") as! [NSDictionary])
        self.rating = dictionary.objectForKey("Rating") as? Float
        
        if let requestsDict = dictionary["Requests"] as? [NSDictionary] {
            self.requests = Request.initWithArray(requestsDict)
        }
        
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        //let placemarkSrc = MKPlacemark(coordinate: currentLocation!.coordinate, addressDictionary: nil)
        let placemarkDes = MKPlacemark(coordinate: (location?.coordinate)!, addressDictionary: nil)
        request.destination = MKMapItem(placemark: placemarkDes)
        request.transportType = .Automobile
        request.requestsAlternateRoutes = false
        let directions: MKDirections = MKDirections(request: request)
        var eta = "--:--:--"
        directions.calculateETAWithCompletionHandler { (response : MKETAResponse?, error : NSError?) -> Void in
            if let response = response {
                print(response.expectedTravelTime)
                eta = UIUtils.stringFromTimeInterval(response.expectedTravelTime)
                //self.eta = UIUtils.stringFromTimeInterval(response.expectedTravelTime)
                //  print(response.expectedTravelTime)
                // print(self.eta)
                //route.distance  = The distance
                //route.expectedTravelTime = The ETA
            } else {
                
            }
        }
        self.eta = eta

    }
    
    class func initShopModelWithArray(array: [NSDictionary]) -> [ShopModel] {
        var trans = [ShopModel]()
        for dict in array {
            trans.append(ShopModel(dictionary: dict))
        }
        return trans
    }
    
    class func getShopsHasRequest(shops: [ShopModel]){
        var result = [ShopModel]()
        
        for shop in shops {
            if shop.requests?.count != 0 {
                result.append(shop)
            }
        }
    }
    
    
    
}


