//
//  SearchDetailsTableViewCell.swift
//  VanTransit
//
//  Created by Rémy Bounthong on 15/11/2018.
//  Copyright © 2018 Rémy Bounthong. All rights reserved.
//

import UIKit

class SearchDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var minutesLeft: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
