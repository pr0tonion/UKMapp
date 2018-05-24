//
//  StoredData.swift
//  UKM
//
//  Created by Marcus Pedersen on 16.04.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class StoredData: NSObject {
    
    
    var eventList = [Event]()
    var newsList = [NewsArticle]()
    
    static let currentSession = StoredData()
    

}
