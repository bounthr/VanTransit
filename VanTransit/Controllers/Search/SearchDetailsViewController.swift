//
//  SearchDetailsViewController.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 15/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import UIKit

class SearchDetailsViewController: UIViewController {

    @IBOutlet weak var searchDetailsTableView: UITableView!
    var busStop: BusStop?
    /*
     http://api.translink.ca/rttiapi/v1/stops/60980/estimates?apikey=[APIKey]
     - Returns the next 6 buses for each route to service the stop in the next 24 hours
     
     http://api.translink.ca/rttiapi/v1/stops/60980/estimates?apikey=[APIKey]&routeNo=050
     - Returns the next 6 buses to service the stop in the next 24 hours for route 50

    */
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         busStop : Optional(VanTransit.BusStop(onStreet: "SMITH AVE", longitude: -123.019724, latitude: 49.24545, wheelchairAccess: 1, routes: ["028", "129"], name: "NB SMITH AVE FS FIR ST", atStreet: "FIR ST", stopNo: 51730, distance: 93, bayNo: 0, city: "BURNABY"))

         */
        self.getBusesInfos()
    }
    
    func getBusesInfos() {

        guard let stopNo = busStop?.stopNo else { return }
        
        let url = "/" + String(stopNo) + "/estimates?"
        AFWrapper.requestGET(urlPartOne: url, urlPartTwo: "&count=10", success: {
            (JSONResponse) -> Void in
            
            print(JSONResponse)
          
            
        }, failure: {
            (error) -> Void in
            print(error)
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
