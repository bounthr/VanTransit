//
//  BusStop.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 14/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import Foundation

class BusStop: NSObject, NSCoding {
    
    var onStreet: String
    var longitude: Double
    var latitude: Double
    var wheelchairAccess: Int
    var routes: [String]
    var name: String?
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
        atStreet = jsonDict["AtStreet"] as? String ?? "none"
        stopNo = jsonDict["StopNo"] as? Int ?? 0
        distance = jsonDict["Distance"] as? Int ?? 0
        bayNo = jsonDict["BayNo"] as? Int ?? 0
        city = jsonDict["City"] as? String ?? "none"
        routes = [String]()
        name = ""

        super.init()

        if let tmp = jsonDict["Name"] as? String {
            print("tmp : \(tmp)")
            let tmpArr = tmp.components(separatedBy: " ")
            var nameTmp = ""
            for str in tmpArr {
                if str.count == 2 {
                    nameTmp += aliasType(for: str) + " "
                } else {
                    nameTmp += str + " "
                }
            }
            print("new name : \(nameTmp.capitalized)")
            name = nameTmp.capitalized
        }
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(onStreet, forKey: "onStreet")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(wheelchairAccess, forKey: "wheelchairAccess")
        aCoder.encode(routes, forKey: "routes")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(atStreet, forKey: "atStreet")
        aCoder.encode(stopNo, forKey: "stopNo")
        aCoder.encode(distance, forKey: "distance")
        aCoder.encode(bayNo, forKey: "bayNo")
        aCoder.encode(city, forKey: "city")
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let onStreet = aDecoder.decodeObject(forKey: "onStreet") as? String else { return nil }
        guard let longitude = aDecoder.decodeDouble(forKey: "longitude") as Double? else { return nil }
        guard let latitude = aDecoder.decodeDouble(forKey: "latitude") as Double? else { return nil }
        guard let wheelchairAccess = aDecoder.decodeInteger(forKey: "wheelchairAccess") as Int? else { return nil }
        guard let routes = aDecoder.decodeObject(forKey: "routes") as? [String] else { return nil }
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else { return nil }
        guard let atStreet = aDecoder.decodeObject(forKey: "atStreet") as? String else { return nil }
        guard let stopNo = aDecoder.decodeInteger(forKey: "stopNo") as Int? else { return nil }
        guard let distance = aDecoder.decodeInteger(forKey: "distance") as Int? else { return nil }
        guard let bayNo = aDecoder.decodeInteger(forKey: "bayNo") as Int? else { return nil }
        guard let city = aDecoder.decodeObject(forKey: "city") as? String else { return nil }

        self.onStreet = onStreet
        self.longitude = longitude
        self.latitude = latitude
        self.wheelchairAccess = wheelchairAccess
        self.routes = routes
        self.name = name
        self.atStreet = atStreet
        self.stopNo = stopNo
        self.distance = distance
        self.bayNo = bayNo
        self.city = city
    }
    
    func aliasType(for alias: String) -> String {
        switch alias {
        case "NB": return "Northbound"
        case "WB": return "Westbound"
        case "SB": return "Southbound"
        case "EB": return "Eastbound"
        case "FS": return "@"
        case "NS": return "@"
        case "N": return "North"
        case "W": return "West"
        case "S": return "South"
        case "E": return "East"
            
        default: return alias
        }
    }
}

