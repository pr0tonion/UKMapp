
//
//  ArrangementListCell.swift
//  UKM
//
//  Created by Marcus Pedersen on 23.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class ArrangementListCell: UITableViewCell {

    @IBOutlet weak var arrangImageView: UIImageView!
    
    @IBOutlet weak var arrangTimeLabel: UILabel!
    
    @IBOutlet weak var arrangTitleLabel: UILabel!
    @IBOutlet weak var arrangPlaceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
