//
//  GoogleSDK.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 14/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON

class GoogleSDK {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var gmsMapView: GMSMapView!
    var zoomLevel: Float = 17
    var didFindMyLocation = false
    var markersArray: [BusStop] = []
    
    let defaultLocation = CLLocation(latitude: 49.283300, longitude: -123.115900) // Granville Station
    
    func initCamera(mapView: UIView) {
        
        print("mapView.bounds : \(mapView.bounds)")
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        self.gmsMapView = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        self.gmsMapView.settings.myLocationButton = true
        self.gmsMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.gmsMapView.isMyLocationEnabled = true
        self.gmsMapView.setMinZoom(10, maxZoom: 18)
        self.gmsMapView.isHidden = true
        self.gmsMapView.tintColor = UIColor.clear
    }
    
    func initLocationManager() {
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    func createMarkers(JSONResponse: JSON) {
        
        if let json = JSONResponse.dictionaryObject {
            if json["Code"] as? String == "1012" {
                if let message = json["Message"] {
                    print(message)
                }
            }
        } else if let json = JSONResponse.arrayObject {
            self.gmsMapView.clear()
            var count = 0
            let iconBusStopImage = UIImage(named: "busIcon")
            
            for mark in json as! [[String : AnyObject]] {
                print(mark)
                
                let busStop = BusStop(jsonDict: mark)
                self.markersArray.append(busStop)
                
                guard busStop.latitude != 0, busStop.longitude != 0 else { break }
                
                let position = CLLocationCoordinate2D(latitude: busStop.latitude, longitude: busStop.longitude)
                let marker = GMSMarker(position: position)
                
                marker.title = busStop.name
                var busRoutes = ""
                for route in busStop.routes {
                    busRoutes += route
                    busRoutes += ", "
                }
                busRoutes = String(busRoutes.dropLast(2))

                marker.snippet = "Stop No.\(String(busStop.stopNo)) - Bus : \(busRoutes)"
                marker.icon = iconBusStopImage
                count += 1
                
                marker.map = self.gmsMapView
            }
        }
    }
}

// Delegates to handle events for the location manager.
extension SearchViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: self.gmsdk.zoomLevel)
        
        if self.gmsdk.gmsMapView.isHidden {
            self.gmsdk.gmsMapView.isHidden = false
            self.gmsdk.gmsMapView.camera = camera
        } else {
            self.gmsdk.gmsMapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print(NSLocalizedString("location_restricted", comment: ""))
        case .denied:
            print(NSLocalizedString("location_denied", comment: ""))
            // Display the map using the default location.
            self.gmsdk.gmsMapView.isHidden = false
        case .notDetermined:
            print(NSLocalizedString("location_undetermined", comment: ""))
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print(NSLocalizedString("location_ok", comment: ""))
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.gmsdk.locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension SearchViewController: GMSMapViewDelegate {
    /*
     // For the custom marker infoView
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
    */
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        self.gmsdk.gmsMapView.selectedMarker = marker;
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {

        performSegue(withIdentifier: "SearchDetailsViewControllerSegue", sender: marker)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if self.mapLoaded == true {
            let coordinate = self.gmsdk.gmsMapView.projection.coordinate(for: mapView.center)
            
            AFWrapper.cancelAllRequests()
            
            let lat = String(format:"%.5f", coordinate.latitude)
            let long = String(format:"%.5f", coordinate.longitude)

            let url = "&lat=" + lat + "&long=" + long + "&radius=200"
            
            AFWrapper.requestGET(urlPartOne: "?", urlPartTwo: url, success: {
                (JSONResponse) -> Void in
                
                self.gmsdk.markersArray.removeAll()
                self.gmsdk.createMarkers(JSONResponse: JSONResponse)
              
                if self.gmsdk.markersArray.count >= 3 {
                    SearchViewController.nbrMarkers = 3
                } else {
                    SearchViewController.nbrMarkers = self.gmsdk.markersArray.count
                }
            }, failure: {
                (error) -> Void in
                print(error)
            })
        }
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if self.middleTargetShowed == false {
            if self.mapLoaded == true {
                self.createMiddleTarget()
            }
        }
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        
        if self.middleTargetShowed == false {
            self.mapLoaded = true
        }
    }
}
