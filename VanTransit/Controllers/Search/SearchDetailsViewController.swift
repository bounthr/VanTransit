//
//  SearchDetailsViewController.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 15/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import UIKit

class SearchDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var busesChoicesTopView: UIView!
    @IBOutlet weak var searchDetailsTableView: UITableView!
    @IBOutlet weak var showAllButton: UIButton!
    
    var busStop: BusStop?
    var busesArray: [Bus] = []
    var busesAllArray: [Bus] = []
    var busesDictForTableView: [Int : [Bus]] = [:]
    
    var chosenBus: Int = 0
    
    /*
     http://api.translink.ca/rttiapi/v1/stops/60980/estimates?apikey=[APIKey]
     - Returns the next 6 buses for each route to service the stop in the next 24 hours
     
     http://api.translink.ca/rttiapi/v1/stops/60980/estimates?apikey=[APIKey]&routeNo=050
     - Returns the next 6 buses to service the stop in the next 24 hours for route 50

    */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchDetailsTableView.delegate = self
        self.searchDetailsTableView.dataSource = self
        
        self.buildTopShowAllAndBusesButton()
        self.getBusesInfos()
    }
    
    
    @IBAction func showAllTapped(_ sender: UIButton) {
        print("Button \(sender.titleLabel) tapped")
        self.chosenBus = sender.tag
        self.searchDetailsTableView.reloadData()

    }
    /*
     Optional(VanTransit.BusStop(onStreet: "SMITH AVE", longitude: -123.019897, latitude: 49.24677, wheelchairAccess: 1, routes: ["028", "129"], name: "SB SMITH AVE FS SPRUCE ST", atStreet: "SPRUCE ST", stopNo: 51780, distance: 89, bayNo: 0, city: "BURNABY"))
     */
    func buildTopShowAllAndBusesButton() {
        print(busStop!)
        var count = 1
        let margin = self.showAllButton.frame.origin.x
        var nextX = self.showAllButton.frame.maxX + margin
        print(self.showAllButton.frame)
        
        for route in (busStop?.routes)! {
            let button = UIButton()
            
            button.setTitle("  \(route)  ", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            
            let buttonTitleSize = ("  \(route)  " as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])

            button.frame.size.height = 30
            button.frame.size.width = buttonTitleSize.width
            button.frame.origin.x = nextX
            button.frame.origin.y = self.showAllButton.frame.origin.y

            nextX = button.frame.maxX + margin
            
            button.backgroundColor = .green
            button.tag = count
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            self.busesChoicesTopView.addSubview(button)

            
            count = count + 1
            print(button.frame)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button \(sender.titleLabel) tapped")
        self.chosenBus = sender.tag
        self.searchDetailsTableView.reloadData()
    }
    
    func getBusesInfos() {

        guard let stopNo = busStop?.stopNo else { return }
        
        let url = "/" + String(stopNo) + "/estimates?"
        AFWrapper.requestGET(urlPartOne: url, urlPartTwo: "&count=10", success: {
            (JSONResponse) -> Void in
            
            
            if let json = JSONResponse.dictionaryObject {
                if ((json["Code"] as? String) != nil) {
                    if let message = json["Message"] {
                        print(message)
                    }
                }
            } else if let json = JSONResponse.arrayObject {
               
                self.busesArray.removeAll()
                var count = 1
                
                for busEstimateInfo in json as! [[String : AnyObject]] {
                    print(busEstimateInfo)
                    let direction = busEstimateInfo["Direction"] as? String ?? "none"
                    let routeName = busEstimateInfo["RouteName"] as? String ?? "none"
                    let routeNo = busEstimateInfo["RouteNo"] as? String ?? "none"

                    if busEstimateInfo["Schedules"] != nil {
                        for busInfo in busEstimateInfo["Schedules"] as! [[String : AnyObject]] {
                            print(busInfo)
                            var bus = Bus(jsonDict: busInfo)
                            
                            bus.direction = direction
                            bus.routeName = routeName
                            bus.routeNo = routeNo
                            self.busesArray.append(bus)
                            self.busesAllArray.append(bus)
                        }
                        self.busesDictForTableView[count] = self.busesArray
                        self.busesArray.removeAll()
                        count = count + 1
                    }
                }
                
                self.busesDictForTableView[0] = self.busesAllArray
                print(self.busesDictForTableView)
                self.searchDetailsTableView.reloadData()
            }
        }, failure: {
            (error) -> Void in
            print(error)
        })
    }
    
// MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.busesDictForTableView[self.chosenBus]?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDetailsTableViewCell", for: indexPath) as? SearchDetailsTableViewCell else { return UITableViewCell() }
        
    // to do
        
        return cell
    }


}
