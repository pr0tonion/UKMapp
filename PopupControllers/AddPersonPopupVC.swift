//
//  AddPersonPopupVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 10.05.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class AddPersonPopupVC: UIViewController {

    @IBOutlet weak var fornavnLabel: UITextField!
    @IBOutlet weak var etternavnLabel: UITextField!
    @IBOutlet weak var alderLabel: UITextField!
    @IBOutlet weak var allergierLabel: UITextField!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var avbrytBtn: UIButton!
    @IBOutlet weak var lagreBtn: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    var delegate: saveUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareView(){
        avbrytBtn.layer.borderWidth = 1
        avbrytBtn.layer.borderColor = UIColor.black.cgColor
        avbrytBtn.layer.cornerRadius = 20
        
        lagreBtn.layer.borderWidth = 1
        lagreBtn.layer.borderColor = UIColor.black.cgColor
        lagreBtn.layer.cornerRadius = 20
        
        popupView.layer.borderColor = UIColor.black.cgColor
        popupView.layer.borderWidth = 1
        popupView.layer.cornerRadius = 20
        
        
    }

    @IBAction func dismissView(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveUser(_ sender: Any) {
        
        if fornavnLabel.text == ""{
            return
        }
        if etternavnLabel.text == ""{
            return
        }
        
        if Int(alderLabel.text!) == nil{
            return
        }
        
        delegate?.addUserToEvent(firstName: fornavnLabel.text!, lastName: etternavnLabel.text!, age: Int(alderLabel.text!)!, allergies: allergierLabel.text ?? "")
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    

}
