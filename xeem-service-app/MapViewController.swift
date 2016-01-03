//
//  MapViewController.swift
//  xeem-service-app
//
//  Created by Le Thanh Tan on 12/30/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FontAwesome_swift

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var shopModel: ShopModel!
    var request: Request!
    let locationManager = CLLocationManager()
    var regionRadius : CLLocationDistance = 0.0;
    var location: CLLocation?
    var lineView = MKOverlayView()
    var polyline = MKPolyline()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.loadMapView()
        self.addAnotation()
        

    }
    
    // MARK: - MapView
    func loadMapView() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
            self.mapView.mapType = MKMapType.Standard
            
            self.regionRadius = 1000 / 1000.0
            self.locationManager.distanceFilter = self.regionRadius
            self.locationManager.startUpdatingLocation()
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func requestDirection() {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!), addressDictionary: nil))
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.request.latitude!, longitude: self.request.longitude!), addressDictionary: nil))
        
        request.requestsAlternateRoutes = false
        request.transportType = .Automobile
        
        let direction = MKDirections(request: request)
        
        direction.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) -> Void in
            guard let unwrappedResponse = response else {return}
            
            let distance = unwrappedResponse.routes.last!.distance/1609.344 * 1.609344
            
            
            self.title = String(format: "%.2f KM", distance)

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
    }
    
    func addAnotation() {
        let requestAnotation = CLLocationCoordinate2D(latitude: self.request.latitude!, longitude: self.request.longitude!)
        let requestMarker = CustomPointAnnotation()
        requestMarker.coordinate = requestAnotation
        requestMarker.requestModel = self.request
        self.mapView.addAnnotation(requestMarker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onDismissViewController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func drawLine() {
//        self.mapView.removeOverlay(self.polyline)
//        
//        var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
//        coordinates.append(CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!))
//        coordinates.append(CLLocationCoordinate2D(latitude: request.latitude!, longitude: request.longitude!))
//        let polyLine = MKPolyline(coordinates: &coordinates, count: 2)
//        self.mapView.addOverlay(polyLine)
//        self.mapView.delegate = self
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
    
extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(self.mapView.userLocation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("identifier") as? FloatingAnnotationView
        let pin: UIImage =         UIImage.fontAwesomeIconWithName(FontAwesome.User, textColor: UIColor(hex:0xE0342f), size: CGSize(width: 20, height: 20))
        
        annotationView = FloatingAnnotationView(annotation: annotation, reuseIdentifier: "identifier", image: pin)
        annotationView!.canShowCallout = false
        return annotationView
    }
    
    // On location updated
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: self.location!.coordinate.latitude, longitude: self.location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        self.requestDirection()
    }
    
    // draw line
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let pr = MKPolylineRenderer(overlay: overlay)
        pr.strokeColor = UIColor.MKColor.BlueLineMap
        pr.lineWidth = 5
        return pr
    }
    
}
    
// MARK: - CustomPointAnnotation
class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
    var requestModel: Request?
}

class FloatingAnnotationView: MKAnnotationView {
    var imageView: UIImageView!
    
    convenience init(annotation: MKAnnotation, reuseIdentifier: String, image: UIImage) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        //self.backgroundColor = UIColor.redColor()
        let frame: CGRect = CGRectMake(0, 0, 40, 40)
        self.frame = frame
        //self.centerOffset = CGPointMake(0, -CGRectGetHeight(frame) / 2)
        let imageView: UIImageView = UIImageView(image: image)
        imageView.frame = frame
        self.imageView = imageView
        self.addSubview(imageView)
    }
}

