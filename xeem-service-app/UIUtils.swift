//
//  UIUtils.swift
//  XEEM
//
//  Created by Giao Tuan on 12/16/15.
//  Copyright © 2015 JadeLe. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

public class UIUtils {
    
    // Set round for an image view
    public static func setRoundImageView(imageView : UIImageView) -> () {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
    }
    
    public static func setupMaterialTextField(textfield: MKTextField) -> () {
        textfield.layer.borderColor = UIColor.clearColor().CGColor
        textfield.floatingPlaceholderEnabled = true
        textfield.tintColor = UIColor.MKColor.AppMainColor
        textfield.rippleLocation = .Right
        textfield.cornerRadius = 0
        textfield.bottomBorderEnabled = true
    }
    
    public static func setupMaterialTextFieldLight(textfield: MKTextField) -> () {
        textfield.layer.borderColor = UIColor.clearColor().CGColor
        textfield.floatingPlaceholderEnabled = true
        textfield.tintColor = UIColor.whiteColor()
        textfield.rippleLocation = .Right
        textfield.cornerRadius = 1
        textfield.textColor = UIColor.whiteColor()
        textfield.bottomBorderEnabled = true
        textfield.rippleLayerColor = UIColor.MKColor.WhiteColor
    }
    
    public static func drawCircle(countLabel: UILabel, view : UIView) {
        let padding : CGFloat = 8
        
        let x = countLabel.layer.position.x - (countLabel.frame.height / 2)
        let y = countLabel.layer.position.y - (countLabel.frame.height / 2)
        let circlePath = UIBezierPath(roundedRect: CGRectMake(x - padding, y - padding, countLabel.frame.width + (2 * padding), countLabel.frame.width + (2 * padding)), cornerRadius: (countLabel.frame.width + (2 * padding)) / 2).CGPath
        
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath
        circleShape.lineWidth = 3
        circleShape.strokeColor = UIColor.MKColor.AppPrimaryColor.CGColor
        circleShape.fillColor = UIColor.clearColor().CGColor
        
        view.layer.addSublayer(circleShape)
    }
    
    public static func convertDistance(distance : Double!) -> String {
        let distance = Double(round(100*((distance)! / 1000))/100)
        return "\(String(distance)) KM"
    }
    
    public static func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "About %02d Minutes", minutes)
    }
    
    public static func getETA(desLocation : CLLocation, label : UILabel) -> () {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = MKMapItem.mapItemForCurrentLocation()
        //let placemarkSrc = MKPlacemark(coordinate: currentLocation!.coordinate, addressDictionary: nil)
        let placemarkDes = MKPlacemark(coordinate: desLocation.coordinate, addressDictionary: nil)
        request.destination = MKMapItem(placemark: placemarkDes)
        request.transportType = .Automobile
        request.requestsAlternateRoutes = false
        let directions: MKDirections = MKDirections(request: request)
        var eta = "--:--:--"
        directions.calculateETAWithCompletionHandler { (response : MKETAResponse?, error : NSError?) -> Void in
            if let response = response {
                print(response.expectedTravelTime)
                eta = UIUtils.stringFromTimeInterval(response.expectedTravelTime)
                label.text = eta
            } else {
                 label.text = eta
            }
        }
    
    }
}
