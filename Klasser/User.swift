//
//  User.swift
//  UKM
//
//  Created by Marcus Pedersen on 07.05.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class User: NSObject {

    var email: String!
    var firstName: String!
    var lastName: String!
    var phoneNumber: String!
    
    static var currentUser = User(email: "", firstName: "", lastName: "", phoneNumber: "")
    
    init(email: String, firstName: String, lastName: String, phoneNumber: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
    
    func fullName() -> String{
        return self.firstName + " " + self.lastName
    }
    
}
