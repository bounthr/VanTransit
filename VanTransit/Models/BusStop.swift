//
//  BusStop.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 14/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import Foundation

func aliasType(for alias: String) -> String {
    switch alias {
        case "NB": return "Northbound"
        case "WB": return "Westbound"
        case "SB": return "Southbound"
        case "EB": return "Eastbound"
        case "ST": return "Street"
        case "AVE": return "Avenue"
        case "FS": return "@"
        case "NS": return "@"
        case "N": return "North"
        case "W": return "West"
        case "S": return "South"
        case "E": return "East"
        
        default: return alias
    }
}

struct BusStop {
    
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
}
