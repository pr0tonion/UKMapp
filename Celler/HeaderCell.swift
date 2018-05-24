//
//  HeaderCell.swift
//  UKM
//
//  Created by Marcus Pedersen on 14.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var headerName: UILabel!
    
    @IBOutlet weak var headerAllName: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
