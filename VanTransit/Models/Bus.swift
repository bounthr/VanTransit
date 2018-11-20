//
//  Bus.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 16/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import Foundation

struct Bus {

    var pattern: String
    var lastUpdate: String
    var scheduleStatus: String
    var addedStop: Bool
    var expectedCountdown: Int
    var cancelledTrip: Bool
    var cancelledStop: Bool
    var expectedLeaveTime: String
    var addedTrip: Bool
    var destination: String
    
    var routeNo: String
    var routeName: String
    var direction: String
    
    init(jsonDict: [String: AnyObject]) {
        
        pattern = jsonDict["Pattern"] as? String ?? "none"
        lastUpdate = jsonDict["LastUpdate"] as? String ?? "none"
        scheduleStatus = jsonDict["ScheduleStatus"] as? String ?? "none"
        addedStop = jsonDict["AddedStop"] as? Bool ?? false
        expectedCountdown = jsonDict["ExpectedCountdown"] as? Int ?? 0
        cancelledTrip = jsonDict["CancelledTrip"] as? Bool ?? false
        cancelledStop = jsonDict["CancelledStop"] as? Bool ?? false
        expectedLeaveTime = jsonDict["ExpectedLeaveTime"] as? String ?? "none"
        addedTrip = jsonDict["AddedTrip"] as? Bool ?? false
        destination = jsonDict["Destination"]?.capitalized ?? "none"
        
        routeNo = "none"
        routeName = "none"
        direction = "none"
    }
}
