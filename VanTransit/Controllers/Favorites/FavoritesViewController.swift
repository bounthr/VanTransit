//
//  FavoritesViewController.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 25/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var favoritesTableView: UITableView!
    var favoriteArray: [BusStop] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favoritesTableView.dataSource = self
        self.favoritesTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let unarchivedObject = UserDefaults.standard.object(forKey: "Favorites")
        if unarchivedObject != nil {
            if let data = unarchivedObject as? Data {
                do {
                    guard let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [BusStop] else {
                        fatalError("loadWidgetDataArray - Can't get Array")
                    }
                    self.favoriteArray = array
                } catch {
                    fatalError("loadWidgetDataArray - Can't encode data: \(error)")
                }
            }
        }
        if self.favoriteArray.count > 0 {
            print("self.favoriteArray : \(self.favoriteArray as [BusStop])")
            for bus in self.favoriteArray as [BusStop] {
                print("bus stop : \(bus.stopNo)")
            }
        }
        self.favoritesTableView.reloadData()
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell() }
        
        let bus = self.favoriteArray[indexPath.row]
        
        cell.stopNo.text = String(bus.stopNo)
        cell.cityName.text = bus.city
        cell.streetName.text = bus.name
        cell.buildBusesViewInCell(busRoutes: bus.routes)
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is SearchDetailsViewController {
            let vc = segue.destination as? SearchDetailsViewController
            if let indexPath = self.favoritesTableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                vc?.busStop = self.favoriteArray[selectedRow]
            }
        }
    }
}
