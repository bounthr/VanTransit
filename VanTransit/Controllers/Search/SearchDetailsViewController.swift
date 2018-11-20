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
    @IBOutlet weak var lastUpdatedAtLabel: UILabel!
    @IBOutlet weak var ActivityLoader: UIActivityIndicatorView!
    
    var busStop: BusStop?
    var busesArray: [Bus] = []
    var busesAllArray: [Bus] = []
    var busesDictForTableView: [Int : [Bus]] = [:]
    var busButtonsArray: [UIButton] = []
    var chosenBus: Int = 0
    var firstUpdated = true
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
        
        self.searchDetailsTableView.isHidden = true
        self.ActivityLoader.startAnimating()
        
        self.buildTopShowAllAndBusesButton()
        self.getBusesInfos()
    }
    
    
    @IBAction func showAllTapped(_ sender: UIButton) {
        for button in self.busButtonsArray {
            button.backgroundColor = UIColor(red: 65/255.0, green: 84/255.0, blue: 178/255.0, alpha: 1.0)
            button.setTitleColor(UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        }
        self.showAllButton.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        self.showAllButton.setTitleColor(UIColor(red: 23/255.0, green: 135/255.0, blue: 207/255.0, alpha: 1.0), for: .normal)

        self.chosenBus = sender.tag
        self.searchDetailsTableView.reloadData()

    }
    /*
     Optional(VanTransit.BusStop(onStreet: "SMITH AVE", longitude: -123.019897, latitude: 49.24677, wheelchairAccess: 1, routes: ["028", "129"], name: "SB SMITH AVE FS SPRUCE ST", atStreet: "SPRUCE ST", stopNo: 51780, distance: 89, bayNo: 0, city: "BURNABY"))
     */
    func buildTopShowAllAndBusesButton() {
        var count = 1
        let margin = self.showAllButton.frame.origin.x
        var nextX = self.showAllButton.frame.maxX + margin
        
        self.showAllButton.layer.cornerRadius = 5.0
        
        for route in (busStop?.routes)! {
            let button = UIButton()
            
            button.setTitle("  \(route)  ", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            
            let buttonTitleSize = ("  \(route)  " as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
            
            button.frame.size.height = self.showAllButton.frame.height
            button.frame.size.width = buttonTitleSize.width
            button.frame.origin.x = nextX
            button.frame.origin.y = self.showAllButton.frame.origin.y
            nextX = button.frame.maxX + margin
            
            button.layer.cornerRadius = 5
            button.tag = count

            button.backgroundColor = UIColor(red: 65/255.0, green: 84/255.0, blue: 178/255.0, alpha: 1.0)
            button.tintColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            self.busButtonsArray.append(button)
            self.busesChoicesTopView.addSubview(button)

            count = count + 1
            print(button.frame)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        self.showAllButton.backgroundColor = UIColor(red: 59/255.0, green: 160/255.0, blue: 216/255.0, alpha: 1.0)
        self.showAllButton.setTitleColor(UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        
        for button in self.busButtonsArray {
            button.backgroundColor = UIColor(red: 65/255.0, green: 84/255.0, blue: 178/255.0, alpha: 1.0)
            button.setTitleColor(UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
        }
        sender.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        sender.setTitleColor(UIColor(red: 65/255.0, green: 84/255.0, blue: 178/255.0, alpha: 1.0), for: .normal)
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
                            
                            if self.firstUpdated == true {
                                self.lastUpdatedAtLabel.text = "Last updated at : " + bus.lastUpdate
                                self.lastUpdatedAtLabel.isHidden = false
                                self.firstUpdated = false
                            }
                            
                            bus.direction = direction
                            bus.routeName = routeName.capitalized
                            bus.routeNo = routeNo
                            self.busesArray.append(bus)
                            self.busesAllArray.append(bus)
                        }
                        self.busesDictForTableView[count] = self.busesArray
                        self.busesArray.removeAll()
                        count = count + 1
                    }
                }
                self.firstUpdated = true
                self.busesDictForTableView[0] = self.busesAllArray.sorted(by: { $0.expectedCountdown < $1.expectedCountdown })
                print(self.busesDictForTableView)
                
                self.ActivityLoader.stopAnimating()
                self.searchDetailsTableView.isHidden = false
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchDetailsTableViewCell", for: indexPath) as? SearchDetailsTableViewCell else { return UITableViewCell() }
        
        var busInfo = self.busesDictForTableView[self.chosenBus]
        
        cell.routeLabel.text = busInfo?[indexPath.row].routeNo
        if let imageDirection = busInfo?[indexPath.row].direction {
            cell.cursorImage.image = UIImage(named: "compass\(String(describing: imageDirection)).png")
        }
        cell.destinationLabel.text = busInfo?[indexPath.row].destination
        cell.minutesLeft.text = String(busInfo?[indexPath.row].expectedCountdown ?? 0)
        
        return cell
    }


}
