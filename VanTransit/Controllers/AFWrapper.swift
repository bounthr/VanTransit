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
     
     http://api.translink.ca/rttiapi/v1/stops?apikey=[APIKey]&lat=49.248523&long=-123.108800&radius=500
     - Returns stops near latitude/longitude coordinates, radius is 500 meters
     
     */
    
    class func requestGET(urlPartOne: String, urlPartTwo: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let url = root + urlPartOne + "apikey=" + transLinkApiKey + urlPartTwo
        
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
