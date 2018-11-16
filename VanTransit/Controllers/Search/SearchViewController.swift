//
//  SearchViewController.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 14/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import UIKit
import GoogleMaps

class SearchViewController: UIViewController {

    @IBOutlet weak var mapView: UIView!

    var gmsdk = GoogleSDK()
    var mapLoaded = false
    var middleTargetShowed = false
    var bottomCGPoint: CGPoint? = nil
    var bottomArrowTapped = true
    var enableBottomViewMvt = false

    var trayOriginalCenter: CGPoint!
    
    static var nbrMarkers = 0
    var bottomViewGesture: UIPanGestureRecognizer?
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var bottomViewFirst = true
    
    let defaultLocation = CLLocation(latitude: 49.283300, longitude: -123.115900) // Granville Station
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addNotificationsObserver()
        
        self.gmsdk.initLocationManager()
        self.gmsdk.locationManager.delegate = self
        
        self.gmsdk.initCamera(mapView: self.mapView)
        self.gmsdk.gmsMapView.delegate = self
        self.mapView.addSubview(self.gmsdk.gmsMapView)
    }
    
    func addNotificationsObserver() {
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(showHomeViewController),
//                                               name: NSNotification.Name("ShowHomeViewController"),
//                                               object: nil)
//
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(showTimesViewController),
//                                               name: NSNotification.Name("ShowTimesViewController"),
//                                               object: nil)
    }

    func createMiddleTarget() {
        
        let midTargetImgView = UIImageView(frame: CGRect(x: self.mapView.frame.width / 2 - 10,
                                                         y: self.mapView.frame.height / 2 - 10,
                                                         width: 20,
                                                         height: 20))
        
        midTargetImgView.image = UIImage(named: "target.png")
        self.mapView.addSubview(midTargetImgView)
        self.middleTargetShowed = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.destination is SearchDetailsViewController {
            let vc = segue.destination as? SearchDetailsViewController

            let marker = sender as? GMSMarker
            for bus in self.gmsdk.markersArray {
                if bus.name == marker?.title {
                    vc?.busStop = bus
                }
            }
        }
    }
}
