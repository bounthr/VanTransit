//
//  FavoritesTableViewCell.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 25/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var stopNo: UILabel!
    @IBOutlet weak var streetName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var busesView: UIView!
    @IBOutlet weak var busNo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func buildBusesViewInCell(busRoutes: [String]) {
        
        let margin = 5.0 as CGFloat
        var nextX = margin
        let height = 20.0 as CGFloat
        
        for route in busRoutes {
            let labelRoute = UILabel()
            
            labelRoute.text = "  \(route)  "
            labelRoute.font = UIFont.boldSystemFont(ofSize: 17)
            
            let labelTextSize = ("  \(route)  " as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
            
            labelRoute.frame.size.height = height
            labelRoute.frame.size.width = labelTextSize.width
            labelRoute.frame.origin.x = nextX
            labelRoute.frame.origin.y = 0
            nextX = labelRoute.frame.maxX + margin
            
            labelRoute.layer.cornerRadius = 10
            
            labelRoute.backgroundColor = UIColor(red: 65/255.0, green: 84/255.0, blue: 178/255.0, alpha: 1.0)
            labelRoute.textColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
            
            self.busesView.addSubview(labelRoute)
        }
    }
}
