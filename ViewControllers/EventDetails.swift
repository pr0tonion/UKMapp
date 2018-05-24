//
//  ArrangementDetaljerVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 17.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit
import EventKit

protocol updateDetailView {
    func updateDetailView(editing: Bool)
}

class EventDetails: UIViewController, updateDetailView {

    
    @IBOutlet weak var arrangTitleLabel: UILabel!
    @IBOutlet weak var arrangTimeLabel: UILabel!
    @IBOutlet weak var arrangPlaceLabel: UILabel!
    @IBOutlet weak var arrangTextView: UITextView!
    @IBOutlet weak var arrangImage: UIImageView!
    @IBOutlet weak var detailsNavBarOutlet: UINavigationItem!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var addToCalendarBtnOutlet: UIButton!
    
    var thisArticle: NewsArticle?
    var thisEvent: Event?
    let eventStore: EKEventStore = EKEventStore()
    var delegate: updateList? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        
        self.detailsNavBarOutlet.leftBarButtonItem = UIBarButtonItem(title: "Tilbake", style: .plain, target: self, action: #selector(self.backBtn))
        self.detailsNavBarOutlet.titleView = UIImageView(image: #imageLiteral(resourceName: "ukmStar"))
        self.detailsNavBarOutlet.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "userIconSmall"), style: .plain, target: self, action: #selector(self.backBtn))
        
        addToCalendarBtnOutlet.layer.cornerRadius = 10
        joinBtn.layer.cornerRadius = 10
        
        
    }

    @objc func backBtn(){
        self.dismiss(animated: true) {
            self.delegate?.checkUserAttendance()
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareView(){
        
        if thisArticle?.title != nil{
            arrangTitleLabel.text = thisArticle?.title
            arrangTimeLabel.text = thisArticle?.dateFile.getDateAndMonthName()
            arrangPlaceLabel.text = "No place for this"
            arrangTextView.text = thisArticle?.eventDesc
            
            if arrangImage != nil{
                
                arrangImage.image = thisArticle?.image
            }else{
                arrangImage.image = #imageLiteral(resourceName: "testphoto")
            }
        }
        if thisEvent?.name != nil{
            
            arrangTitleLabel.text = thisEvent?.name
            arrangTimeLabel.text = thisEvent?.dateFile.getDateAndTime()
            arrangPlaceLabel.text = thisEvent?.place
            arrangTextView.text = thisEvent?.eventDescription
            if thisEvent?.imageFile != nil{
                
                arrangImage.image = thisEvent?.imageFile
            }else{
                arrangImage.image = #imageLiteral(resourceName: "testphoto")
            }
            
        }else{
            print("No event or news found")
        }
        
        if thisEvent?.isAttending == true{
            joinBtn.setTitle("Endre eller fjern påmelding", for: .normal)
            
            
            
        }else{
            joinBtn.setTitle("Påmelding med UKMid", for: .normal)
        }
    }
    
    @IBAction func addToCalendar(_ sender: Any){
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil){
                
                let event: EKEvent = EKEvent(eventStore: self.eventStore)
                
                event.title = self.thisEvent?.name
                event.startDate = self.thisEvent?.dateFile
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                do{
                    try self.eventStore.save(event, span: .thisEvent)
                }catch{
                    print("Event did not get saved, error:" + error.localizedDescription)
                }
                print("event saved")
                
            }else{
                print("Event did not get saved, error:" + (error?.localizedDescription)!)
            }
            
            
        }
        
    }
    
    @IBAction func signUpToEventBtn(_ sender: Any) {
        
        if UserDefaults.standard.object(forKey: "userPhoneNumber") != nil{
            performSegue(withIdentifier: "segueToEventSignUp", sender: self)
        }else{
            createAlert(title: "Du er ikke innlogget", btnText: "OK", message: "Vennligst logg inn før du melder deg på, detta kan gjøres i instillinger")
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToEventSignUp"{
            
            let signUpVC: EventSignUpVC = segue.destination as! EventSignUpVC
            
            signUpVC.thisEvent = thisEvent
            signUpVC.delegate = self
            if thisEvent!.isAttending{
                signUpVC.getAttendanceInfo()
            }
            
            
            
        }
    }
    
    func updateDetailView(editing: Bool) {
        
        if editing{
            thisEvent?.isAttending = true
        }else{
            //Avbryt knapp
           thisEvent?.isAttending = false
        }
        
        
        prepareView()
    }
    
    func createAlert(title: String, btnText: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: btnText, style: .default, handler: { (alertAction) in
            
            
        }))
        self.present(alert, animated: true)
        
    }
    

}
