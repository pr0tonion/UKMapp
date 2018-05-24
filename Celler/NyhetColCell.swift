//
//  NyhetColCell.swift
//  UKM
//
//  Created by Marcus Pedersen on 17.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class NyhetColCell: UICollectionViewCell {
    
    @IBOutlet weak var nyhetImage: UIImageView!
    @IBOutlet weak var nyhetTitle: UILabel!
    @IBOutlet weak var nyhetTimeWritten: UILabel!
    
    var bilde: UIImage?{
        didSet{
           self.nyhetImage.image = bilde
            self.setNeedsLayout()
        }
    }
    
}
