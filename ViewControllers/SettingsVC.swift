//
//  SettingsVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 01.05.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var notificationSettingsView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var calendarSwitch: UISwitch!
    @IBOutlet weak var loginOrOutBtnOutlet: UIButton!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var loggedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserSettings(){
        //Userdefaults
        
    }
    
    
    
    func prepareView(){
        
        navBarItem.leftBarButtonItem = UIBarButtonItem(title: "Tilbake", style: .done, target: self, action: #selector(dismissVC))
        
        notificationSettingsView.addBottomBorderWithColor(color: UIColor.black, width: 1)
        calendarView.addBottomBorderWithColor(color: UIColor.black, width: 1)
        reportView.addBottomBorderWithColor(color: UIColor.black, width: 1)
        
        if (UserDefaults.standard.object(forKey: "userPhoneNumber") as? String) != nil{
            
            let cachedUser = User(email: UserDefaults.standard.object(forKey: "userEmail") as! String,
                                  firstName: UserDefaults.standard.object(forKey: "userFirstName") as! String,
                                  lastName: UserDefaults.standard.object(forKey: "userLastName") as! String,
                                  phoneNumber: UserDefaults.standard.object(forKey: "userPhoneNumber") as! String)
            
            loginOrOutBtnOutlet.setTitle("Logg ut", for: .normal)
            loginOrOutBtnOutlet.backgroundColor = UIColor(red: CGFloat(221.0/255), green: CGFloat(148.0/255), blue: CGFloat(55.0/255), alpha: 1.0)
            loggedIn = true
            
            
        }else{
            loginOrOutBtnOutlet.setTitle("Logg inn", for: .normal)
            loggedIn = false
        }
        
        
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginOrOutBtn(_ sender: Any) {
        
        if loggedIn{
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userFirstName")
            UserDefaults.standard.removeObject(forKey: "userLastName")
            UserDefaults.standard.removeObject(forKey: "userPhoneNumber")
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            
            present(loginVC, animated: true)
        }else{
            
            UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.removeObject(forKey: "userFirstName")
            UserDefaults.standard.removeObject(forKey: "userLastName")
            UserDefaults.standard.removeObject(forKey: "userPhoneNumber")
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LoginVC
            
            present(loginVC, animated: true)
        }
            
        
    }
    
    
    

}
