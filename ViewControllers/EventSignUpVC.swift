//
//  EventSignUpVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 26.04.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit
import Firebase

protocol saveUser {
    func addUserToEvent(firstName: String, lastName: String, age: Int, allergies: String)
}

struct EventUser {
    let firstName: String!
    let lastName: String!
    let age: Int!
    let allergies: String?
    
    init(firstName: String, lastName: String, age: Int, allergies: String? ) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        
        if allergies != nil{
        self.allergies = allergies
        }else{
            self.allergies = nil
        }
        
    }
    
    func getFullName() -> String{
        
        return self.firstName + " " + self.lastName
    }
    
}

class EventSignUpVC: UIViewController, saveUser {
    
    @IBOutlet weak var navItemOutlet: UINavigationItem!
    @IBOutlet weak var fornavnLabel: UITextField!
    @IBOutlet weak var etterNavnLabel: UITextField!
    @IBOutlet weak var alderLabel: UITextField!
    @IBOutlet weak var mobilLabel: UITextField!
    @IBOutlet weak var allergiLabel: UITextField!
    @IBOutlet weak var saveOrDeleteStackView: UIStackView!
    @IBOutlet weak var lagreBtnOutlet: UIButton!
    @IBOutlet weak var leggTilPersonOutlet: UIButton!
    @IBOutlet weak var inputStackView: UIStackView!
    
    var peopleAddedList: [EventUser] = []
    var thisEvent: Event?
    var delegate: updateDetailView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        
        if User.currentUser != nil{
        fornavnLabel.text = User.currentUser.firstName
        etterNavnLabel.text = User.currentUser.lastName
        mobilLabel.text = User.currentUser.phoneNumber
        }
    }

    func prepareView(){
        
        lagreBtnOutlet.layer.cornerRadius = 10
        leggTilPersonOutlet.layer.cornerRadius = 10
        
        navItemOutlet.leftBarButtonItem = UIBarButtonItem(title: "Tilbake", style: .done, target: self, action: #selector(self.dismissVC))
        navItemOutlet.titleView = UIImageView(image: #imageLiteral(resourceName: "ukmStar"))
        
        
        if thisEvent!.isAttending{
            let deleteBtn = UIButton(type: UIButtonType.custom)
            deleteBtn.setTitle("Meld deg av", for: .normal)
            deleteBtn.backgroundColor = UIColor.red
            deleteBtn.layer.cornerRadius = 10
            
            deleteBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeUserFromEvent)))
            
            saveOrDeleteStackView.addArrangedSubview(deleteBtn)
            
            
            
        }else{
            
        }
        
        
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func LagreBtn(_ sender: Any) {
        checkInputs { (result) in
            
            if result == true{
                var firebaseRef: DatabaseReference!
                firebaseRef = Database.database().reference().child("events").child(String(thisEvent!.id)).child("attendees").child(User.currentUser.phoneNumber)
                
                firebaseRef.observeSingleEvent(of: .value, with: { (snapShot) in
                   
                    
                    for person in self.peopleAddedList{
                    let personsRef = firebaseRef.childByAutoId()
                        
                        let personValues: [String : Any] = ["firstName" : person.firstName,
                                                            "lastName": person.lastName,
                                                            "age": person.age,
                                                            "allergies": person.allergies ?? ""]
                        
                    personsRef.updateChildValues(personValues)
                    }
                    
                    let attendanceValues: [String : Any] = ["firstName": User.currentUser.firstName,
                                                            "lastName": User.currentUser.lastName,
                                                            "age": Int(self.alderLabel.text!)!,
                                                            "Allergies": self.allergiLabel.text!
                                                            ]
                    
                    firebaseRef.updateChildValues(attendanceValues)
                    
                    self.delegate?.updateDetailView(editing: true)
                    self.dismissVC()
                })
                
                
            }else{
                return
            }
            
        }
        
        
    }
    
    @IBAction func addPersonBtn(_ sender: Any) {
        
        let popupSB = UIStoryboard(name: "PopupSB", bundle: nil).instantiateViewController(withIdentifier: "addPersonPopup") as! AddPersonPopupVC
        popupSB.delegate = self
        
        popupSB.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        self.present(popupSB, animated: true)
    }
    
    func addUserToEvent(firstName: String, lastName: String, age: Int, allergies: String) {
        
        let person = EventUser(firstName: firstName, lastName: lastName, age: age, allergies: allergies)
        let personCell = PersonStackCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        personCell.name = person.getFullName()
        personCell.age = person.age
        personCell.isHidden = false
        personCell.backgroundColor = UIColor.blue
        inputStackView.addArrangedSubview(personCell)
        inputStackView.reloadInputViews()
        print(inputStackView.subviews.last)
        
        peopleAddedList.append(person)
        
        
    }
    
    @objc func removeUserFromEvent(){
        var firebaseRef: DatabaseReference!
        firebaseRef = Database.database().reference().child("events").child(String(thisEvent!.id)).child("attendees").child(User.currentUser.phoneNumber)
        
        firebaseRef.removeValue()
        
        delegate?.updateDetailView(editing: false)
        
        self.dismissVC()
        
    }
    
    
    func checkInputs(completion: (_ result: Bool)->()){
        
        //fornavnLabel
        if fornavnLabel.text == ""{
            createAlert(title: "Ingen fornavn", text: "Vennligst legg fyll inn ditt fornavn", btnText: "OK", skippable: false)
            return
        }
        
        //etterNavnLabel
        if etterNavnLabel.text == ""{
            createAlert(title: "Ingen etternavn", text: "Vennligst fyll inn ditt etternavn", btnText: "OK", skippable: false)
            return
        }
        //alderLabel
        if alderLabel.text == ""{
            createAlert(title: "Ingen alder", text: "Vennligst fyll inn din alder", btnText: "OK", skippable: false)
            return
        }else{
            if Int(alderLabel.text!) == nil{
            createAlert(title: "Alder er ikke et tall", text: "Vennligst fyll ut din alder som nummer", btnText: "OK", skippable: false)
                return
            }
        }
        
        //mobilLabel
        
        if mobilLabel.text == ""{
            createAlert(title: "Mobilnummer ikke funnet", text: "Vennligst fyll inn ditt mobilnummer", btnText: "OK", skippable: false)
            return
        }else{
            
            if Int(mobilLabel.text!) == nil{
                createAlert(title: "Mobilnummer er ikke tall", text: "Vennligst fyll inn ditt mobilnummer med bare tall", btnText: "OK", skippable: false)
                return
            }
            
        }
        
        
        completion(true)
        
    }
    
    
    func createAlert(title: String, text: String, btnText: String, skippable: Bool){
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: btnText, style: .default, handler: { (alertAction) in
            
            return
        }))
        
        
        self.present(alert, animated: true)
        
        
    }
    
    func getAttendanceInfo(){
        // TODO - sjekk om personer er vedlagt
        var firebaseRef: DatabaseReference!
        firebaseRef = Database.database().reference().child("events").child(String(thisEvent!.id)).child("attendees").child(User.currentUser.phoneNumber)
        
        firebaseRef.observeSingleEvent(of: .value, with: { (snapShot) in
            
            let dict = snapShot.value as? [String: Any]
            
            let allergies = dict!["Allergies"] as? String
            let act = dict!["act"] as? String
            let age = dict!["age"] as? Int
            
            self.allergiLabel.text = allergies
            self.alderLabel.text = String(age!)
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            // TODO - Create alert that they could not find info
        }
        
    }
    
    func setUpNotification(){
        
        //NotificationCenter.default.post(name: <#T##NSNotification.Name#>, object: <#T##Any?#>)
        
    }
    
    
    
}
