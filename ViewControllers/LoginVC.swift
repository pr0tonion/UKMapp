//
//  LoginVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 14.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var loggInnBtnOutlet: UIButton!
    @IBOutlet weak var createUkmIdOutlet: UIButton!
    @IBOutlet weak var noUkmIdOutlet: UIButton!
    
    var ukmIDType: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loggInnBtnOutlet.layer.cornerRadius = 5
        createUkmIdOutlet.layer.cornerRadius = 5
        noUkmIdOutlet.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
    }

    @IBAction func loggInnBtn(_ sender: Any) {
        
        ukmIDType = 0
        performSegue(withIdentifier: "segueToCreateVC", sender: self)
        
        
    }
    @IBAction func opprettUkmIdBtn(_ sender: Any) {
        
        ukmIDType = 1
        performSegue(withIdentifier: "segueToCreateVC", sender: self)
        
        
    }
    
    @IBAction func noUkmIdBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "segueToTabBar", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //segueToCreateVC
        if segue.identifier == "segueToCreateVC"{
            let createVC : CreateUKMID_VC = segue.destination as! CreateUKMID_VC
            
            if ukmIDType == 1{
            createVC.loginType = .Create
            }else{
            createVC.loginType = .Login
            }
            
            
        }
        
    }
  

}
