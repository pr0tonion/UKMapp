//
//  CreateUKMID_VC.swift
//  UKM
//
//  Created by Marcus Pedersen on 18.04.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit
import WebKit
import Firebase

enum ukmLoginType{
    
    case Login
    case Create
    
}

class CreateUKMID_VC: UIViewController {
    
    @IBOutlet weak var inputStackView: UIStackView!
    @IBOutlet weak var navigationItemOutlet: UINavigationItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var regBtnOutlet: UIButton!
    @IBOutlet weak var passWordTextField: UITextField!
    
    var loginType: ukmLoginType!
    let ukmCreateUrl = "https://delta.ukm.no/register/"
    let ukmLoginUrl = "https://delta.ukm.no/"
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func prepareView(){
        
        navigationItemOutlet.leftBarButtonItem = UIBarButtonItem(title: "Tilbake", style: .done, target: self, action: #selector(self.backBtn))
        
        switch loginType {
        case .Create:
            passWordTextField.isSecureTextEntry = true
            phoneNumberTextField.keyboardType = .numberPad
            emailTextField.keyboardType = .emailAddress
            
            
                break
        case .Login:
            
            phoneNumberTextField.isHidden = true
            lastNameTextfield.isHidden = true
            passWordTextField.isHidden = true
            emailTextField.placeholder = "Mobilnummer"
            emailTextField.keyboardType = .numberPad
            firstNameTextField.placeholder = "Passord"
            firstNameTextField.isSecureTextEntry = true
            
            regBtnOutlet.setTitle("Logg inn", for: .normal)
            
            break
        default:
            return
        }
        
        
        
    }
    
    @objc func backBtn(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func regBtn(_ sender: Any) {
        
        switch loginType {
        case .Create:
            
            
                if emailTextField.text == ""{
                    createAlert(title: "Epost felt er tomt", btnText: "OK", message: "Vennligst legg til din epost")
                    return
                }
                let validEmail: Bool = validateEmail(enteredEmail: emailTextField.text!)
                
                if validEmail == false{
                    createAlert(title: "Email ikke riktig", btnText: "OK", message: "Vennligst fyll ut en korrekt epost adresse")
                    return
                }
                
                if firstNameTextField.text == ""{
                    
                    createAlert(title: "Fornavn er tomt", btnText: "OK", message: "Vennligst fyll ut ditt fornavn")
                    
                }
                if lastNameTextfield.text == ""{
                    
                    createAlert(title: "Etternavn er tomt", btnText: "OK", message: "Vennligst fyll ut ditt etternavn")
                    return
                    
                }
                if phoneNumberTextField.text == ""{
                    
                    createAlert(title: "Mobilnummer er tomt", btnText: "OK", message: "Vennligst legg til ditt mobilnummer")
                    return
            }
                
                if Int(phoneNumberTextField.text!) == nil{
                    createAlert(title: "Mobilnummer er ikke nummer", btnText: "OK", message: "Vennligst fyll ut mobilnummer med bare tall")
                    return
                }
                
                if passWordTextField.text! == ""{
                    createAlert(title: "Passord ikke funnet", btnText: "OK", message: "Vennligst fyll ut ditt passord")
                    return
                    
                }
                
                saveUserInDB(email: emailTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextfield.text!, phoneNumber: phoneNumberTextField.text!, passWord: passWordTextField.text!)
                
            break
        case .Login:
            
            if emailTextField.text == ""{
                
                createAlert(title: "Mobilnummer ikke funnet", btnText: "OK", message: "Vennligst fyll inn ditt mobilnummer")
                return
            }
            
            if Int(emailTextField.text!) == nil{
                //TODO - if mobnr < 8
               createAlert(title: "Mobilnummer ikke funnet", btnText: "OK", message: "Vennligst fyll ut mobilnummer med bare tall")
                
            }
            if firstNameTextField.text == ""{
                createAlert(title: "Passord ikke funnet", btnText: "OK", message: "Vennligst fyll inn ditt passord")
                return
            }
            
            logInUser(phoneNumber: emailTextField.text!, password: firstNameTextField.text!)
            break
        
        default:
            return
        }
        
        
        
        
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    
    func saveUserInDB(email: String,firstName: String, lastName: String, phoneNumber: String, passWord: String){
        var firebaseRef: DatabaseReference!
        firebaseRef = Database.database().reference().child("users").child(phoneNumber)
        
        
        
        let userValues: [String: Any] = ["email": email,
                                         "firstName": firstName,
                                         "lastName": lastName,
                                         "password" : passWord]
        firebaseRef.setValue(userValues) { (error, dbRef) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
        }
        
        let loggedInUser = User.init(email: email, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)

        UserDefaults.standard.set(loggedInUser.email, forKey: "userEmail")
        UserDefaults.standard.set(loggedInUser.firstName, forKey: "userFirstName")
        UserDefaults.standard.set(loggedInUser.lastName, forKey: "userLastName")
        UserDefaults.standard.set(phoneNumber, forKey: "userPhoneNumber")
        UserDefaults.standard.synchronize()
        let mainVC = storyBoard.instantiateViewController(withIdentifier: "mainTabBarController") as! MainTabBarController
        
        User.currentUser = loggedInUser
        
        self.present(mainVC, animated: true, completion: nil)
        
    }
    
    func logInUser(phoneNumber: String, password: String){
        var firebaseRef: DatabaseReference!
        firebaseRef = Database.database().reference().child("users").child(phoneNumber)
        
        firebaseRef.observeSingleEvent(of: .value) { (snapShot) in
            
            if snapShot.exists(){
                let returnedValue = snapShot.value as? NSDictionary
                
                if password == returnedValue!["password"] as? String{
                
                UserDefaults.standard.set(returnedValue!["email"] as? String, forKey: "userEmail")
                UserDefaults.standard.set(returnedValue!["firstName"] as? String, forKey: "userFirstName")
                UserDefaults.standard.set(returnedValue!["lastName"], forKey: "userLastName")
                print(snapShot.key)
                UserDefaults.standard.set(snapShot.key, forKey: "userPhoneNumber")
                UserDefaults.standard.synchronize()
                
                    var cachedUser = User(email: UserDefaults.standard.object(forKey: "userEmail") as! String,
                                          firstName: UserDefaults.standard.object(forKey: "userFirstName") as! String,
                                          lastName: UserDefaults.standard.object(forKey: "userLastName") as! String,
                                          phoneNumber: UserDefaults.standard.object(forKey: "userPhoneNumber") as! String)
                    
                    User.currentUser = cachedUser
                    
                    
                    let tabBarVC = self.storyBoard.instantiateViewController(withIdentifier: "mainTabBarController")
                    self.present(tabBarVC, animated: true, completion: nil)
                }else{
                    
                    self.createAlert(title: "Feil passord", btnText: "OK", message: "Passordet er feil, skriv inn korrekt passord")
                    return
                }
                
            }else{
                self.createAlert(title: "Bruker ikke funnet", btnText: "OK", message: "Bruker ble ikke funnet, har du skrevet inn riktig mobilnummer?")
            }
            
            
            
            
        }
        
        
    }
    
    
    func createAlert(title: String, btnText: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: btnText, style: .default, handler: { (alertAction) in
            
            
        }))
        self.present(alert, animated: true)
        
    }
        
}
    

    

