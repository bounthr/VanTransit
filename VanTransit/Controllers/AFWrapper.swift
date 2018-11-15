//
//  AFWrapper.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 14/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let transLinkApiKey = UserDefaults.standard.string(forKey: "transLinkApiKey") ?? "nil"
let root = "http://api.translink.ca/rttiapi/v1/stops"

class AFWrapper {
    
    /*
     http://api.translink.ca/rttiapi/v1/stops/55612?apikey=[APIKey]
     - Returns stop details for stop 55612
     
     http://api.translink.ca/rttiapi/v1/stops?apikey=[APIKey]&lat=49.187706&long=-122.850060
     - Returns stops near latitude/longitude coordinates, radius is defaulted to 500 meters
     
     http://api.translink.ca/rttiapi/v1/stops?apikey=[APIKey]&lat=49.187706&long=-122.850060&routeNo=590
     - Returns stops near latitude/longitude coordinates, radius is defaulted to 500 meters and filtered to only show stops serving route 590
     
     http://api.translink.ca/rttiapi/v1/stops?apikey=[APIKey]&lat=49.248523&long=-123.108800&radius=500
     - Returns stops near latitude/longitude coordinates, radius is 500 meters
     
     */
    
    class func requestGET(stops: Int? = nil, latitude: Double? = nil, longitude: Double? = nil, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        var url = root
        
        if stops == nil {
            if let latitude = latitude, let longitude = longitude {
                let lat = String(format:"%.5f", latitude)
                let long = String(format:"%.5f", longitude)
                
                url = url + "?apikey=" + transLinkApiKey + "&lat=" + lat + "&long=" + long + "&radius=200"
            }
        } else {
            if let stops = stops {
                url = url + "/" + String(stops) + "?apikey=" + transLinkApiKey
            }
        }
        
        print("URL : \(url)")
        let header = ["content-type" : "application/json",
                      "accept" : "application/json"]
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: header).validate(contentType: ["application/json"]).responseJSON { (responseObject) -> Void in
                            
                            if responseObject.result.isSuccess {
                                let resJson = JSON(responseObject.result.value!)
                                success(resJson)
                            }
                            if responseObject.result.isFailure {
                                let error : Error = responseObject.result.error!
                                failure(error)
                            }
        }
    }
    
    class func cancelAllRequests() {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}
