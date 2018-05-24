//
//  Arrangement.swift
//  UKM
//
//  Created by Marcus Pedersen on 17.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class Event: NSObject {

    var id: Int!
    var name: String!
    var place: String!
    var date: String!
    var imageLink: String?
    var spotsLeft: Int?
    var eventDescription: String?
    var imageFile: UIImage?
    var dateFile: Date!
    var isAttending: Bool = false
    

    func stringToDate(dateString: String) -> Date{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+1:00")
        
        
        let date = dateFormatter.date(from: dateString)
        
        
        return date!
        
        
    }
    
}
