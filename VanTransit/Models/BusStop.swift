//
//  BusStop.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 14/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import Foundation

struct BusStop {
    
    var onStreet: String
    var longitude: Double
    var latitude: Double
    var wheelchairAccess: Int
    var routes: [String]
    var name: String
    var atStreet: String
    var stopNo: Int
    var distance: Int
    var bayNo: Int
    var city: String
    
    init(jsonDict: [String: AnyObject]) {
        
        onStreet = jsonDict["OnStreet"] as? String ?? "none"
        longitude = jsonDict["Longitude"] as? Double ?? 0
        latitude = jsonDict["Latitude"] as? Double ?? 0
        wheelchairAccess = jsonDict["WheelchairAccess"] as? Int ?? 0
        name = jsonDict["Name"] as? String ?? "none"
        atStreet = jsonDict["AtStreet"] as? String ?? "none"
        stopNo = jsonDict["StopNo"] as? Int ?? 0
        distance = jsonDict["Distance"] as? Int ?? 0
        bayNo = jsonDict["BayNo"] as? Int ?? 0
        city = jsonDict["City"] as? String ?? "none"
        routes = [String]()
        
        if let tmp = jsonDict["Routes"] as? String {
            if tmp.contains(",") {
                let tmpArray = tmp.components(separatedBy: ",")
                for var busN in tmpArray {
                    if busN.first == " " {
                        busN.remove(at: busN.startIndex)
                    }
                    routes.append(busN)
                }
            } else {
                routes.append(tmp)
            }
        }
    }
}
