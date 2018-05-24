//
//  Nyhet.swift
//  UKM
//
//  Created by Marcus Pedersen on 17.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class NewsArticle: NSObject {
    
    var title: String!
    var imageLink: String!
    var image: UIImage?
    var dateWritten: String!
    var dateFile: Date!
    var eventDesc: String!
    var url: String!
    
    func stringToDate(dateString: String) -> Date{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+1:00")
        
        
        let date = dateFormatter.date(from: dateString)
        
       
        return date!
       
        
    }
    

}
