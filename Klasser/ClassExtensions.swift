//
//  ClassExtensions.swift
//  UKM
//
//  Created by Marcus Pedersen on 09.04.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class ClassExtensions: NSObject {

}

extension Date {
    
    func getDateAndMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getDateAndTime() -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d MMM HH:mm"
        
        let string = dateFormatter.string(from: self)
        
        return string
        
    }
    
    func getNumericalDate() -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DD.MM.YYYY"
        
        let string = dateFormatter.string(from: self)
        
        return string
        
    }
    
    
}
extension UIView {
    
    //Hentet fra: https://stackoverflow.com/questions/7666863/uiview-bottom-border
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
