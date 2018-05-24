//
//  ArrangementerVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 14.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase


protocol updateList {
    func checkUserAttendance()
}

class EventsVC: UIViewController, UITableViewDataSource,UITableViewDelegate, updateList {
    
    
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var eventList: [Event] = []
    var joinedEvents: [Event] = []
    var clickedIndex: Int = 0
    var workShopHeaderRow: Int = 5
    let headerTitles = ["Påmeldt","Workshops"]
    var eventToSend: Event?
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       prepareView()
        
        if StoredData.currentSession.eventList.count > 0{
            eventList = StoredData.currentSession.eventList
            eventList.remove(at: 0)
            
            checkUserAttendance()
            
            
        }else{
            getEvents()
        }
        
       
    }

    
    //arrangListSegueToDetails

    func prepareView(){
        navBarItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ukmStar"))
        navBarItem.titleView?.isUserInteractionEnabled = true
        
        let rightNavItemLogo = UIBarButtonItem(image: #imageLiteral(resourceName: "settingsIcon"), style: .plain, target: self, action: #selector(goToSettings))
        navBarItem.setRightBarButton(rightNavItemLogo, animated: true)
    }
    
    @objc func goToSettings(){
        let mainSB = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC") as! SettingsVC
        
        
        mainSB.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        self.present(mainSB, animated: true)
    }
    
    
    
    func getEvents(){
        
        let url = "https://rsvp.ukm.no/api/events/place-4920/json/"
        var imageFailure: Int = 0
        
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.value != nil{
                
                let swiftJson = JSON(response.result.value!)
                
                for eventJson in swiftJson.array!{
                    var event = Event()
                    event.name = eventJson["name"].string
                    event.place = eventJson["place"].string
                    event.id = eventJson["id"].int
                    
                    
                    
                    if eventJson["image"].string != ""{
                        event.imageLink = eventJson["image"].string
                        
                        
                        Alamofire.request(event.imageLink!).responseImage(completionHandler: { (response) in
                            
                            
                            if let image = response.result.value{
                                
                                let t = UIImage(data: response.data!)
                                
                                event.imageFile = t
                                event.spotsLeft = eventJson["spots"].int
                                event.eventDescription = eventJson["description"].string
                                event.date = eventJson["date_start"]["date"].string
                                
                                self.eventList.append(event)
                                
                                
                                
                                
                                if (swiftJson.array?.count)! - imageFailure == self.eventList.count{
                                    StoredData.currentSession.eventList = self.eventList
                                    
                                    self.eventsTableView.reloadData()
                                }
                                
                            }else{
                                print(response.error!.localizedDescription)
                                
                                
                                // NOTE - Om et bilde ikke er kompitabelt med alamoImage så vil det ikke bli lagt til i listen
                                
                            }
                            
                        })
                        
                    }else{
                        event.spotsLeft = eventJson["spots"].int
                        event.eventDescription = eventJson["description"].string
                        event.date = eventJson["date_start"]["date"].string
                        //TODO - Add temp image
                        self.eventList.append(event)
                        
                        
                        if (swiftJson.array?.count)! == self.eventList.count{
                            
                           
                            StoredData.currentSession.eventList = self.eventList
                            self.eventsTableView.reloadData()
                        }
                        
                    }
                    
                    
                    if (swiftJson.array?.count)! - imageFailure == self.eventList.count{
                        
                        StoredData.currentSession.eventList = self.eventList
                        
                        self.eventsTableView.reloadData()
                    }
                    
                }
                self.checkUserAttendance()
                
                
            }else{return}
            
        }
        
    }
    
    func checkUserAttendance(){
        
        var firebaseRef: DatabaseReference!
        firebaseRef = Database.database().reference().child("events")
        var eventID: String? = nil
        firebaseRef.observeSingleEvent(of: .value) { (snapShot) in
            
            
            for eventKey in snapShot.children.allObjects as! [DataSnapshot]{
                
                eventID = eventKey.key
                
                for n in eventKey.children.allObjects as! [DataSnapshot]{
                    
                    for attendees in n.children.allObjects as! [DataSnapshot]{
                        
                        if attendees.key == User.currentUser.phoneNumber{
                            
                            for event in self.eventList{
                                
                                if String(event.id) == eventID{
                                    event.isAttending = true
                                    self.joinedEvents.append(event)
                                    
                                    
                                }else{
                                   
                                }
                               
                            }
                            
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
            }
            self.removeOldCells()
            
        }
    }
    
    func removeOldCells(){
        
        
        var joinedCount = 0
        for joinedEvent in joinedEvents{
            var eventCount = 0
            
            if joinedEvent.isAttending == false{
                eventList.append(joinedEvents[joinedCount])
                joinedEvents.remove(at: joinedCount)
            }
            
            for event in eventList{
                
                if event.isAttending{
                    eventList.remove(at: eventCount)
                }
                
                eventCount += 1
                
            }
            joinedCount += 1
        }
        eventsTableView.reloadData()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if section == 1{
            return eventList.count
        }else{
            return joinedEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell") as! ArrangementListCell
        
        
            let title = indexPath.section == 1 ? eventList[indexPath.row].name : joinedEvents[indexPath.row].name
            let time = indexPath.section == 1 ? eventList[indexPath.row].dateFile.getDateAndTime() : joinedEvents[indexPath.row].dateFile.getDateAndTime() as! String
            let place = indexPath.section == 1 ? eventList[indexPath.row].spotsLeft : joinedEvents[indexPath.row].spotsLeft
            let id = indexPath.section == 1 ? eventList[indexPath.row].id : joinedEvents[indexPath.row].id
        
        
        
            cell.arrangTitleLabel.text = title
            cell.arrangTimeLabel.text = time
            cell.arrangPlaceLabel.text = String(place!)
        
        if indexPath.section == 1{
            cell.contentView.backgroundColor = nil
            if eventList[indexPath.row].imageFile != nil{
                
                cell.arrangImageView.image = eventList[indexPath.row].imageFile
            }
        }else{
            cell.contentView.backgroundColor = UIColor(red: CGFloat(176.0/255), green: CGFloat(213.0/255), blue: CGFloat(184.0/255), alpha: 1.0)
            
            if joinedEvents[indexPath.row].imageFile != nil{
                
                cell.arrangImageView.image = joinedEvents[indexPath.row].imageFile
            }
        }
        
        
            
            return cell
            
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            eventToSend = joinedEvents[indexPath.row]
        }else{
            eventToSend = eventList[indexPath.row]
        }
       
        
        performSegue(withIdentifier: "arrangListSegueToDetails", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "arrangListSegueToDetails"{
            
            let detailVC: EventDetails = segue.destination as! EventDetails
            
            detailVC.thisEvent = eventToSend
            detailVC.delegate = self
            
        }
        
    }
   
   

}
