//
//  NyheterVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 14.03.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class NyheterVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
   //TODO - Cache disse to listene? dermed sjekke om disse listene finnes i cachen når arangementer og nyheter åpnes?
    var nyhetList: [NewsArticle] = []
    var arrangList: [Event] = []
    var objectTosend:NSObject?
    var cellIndex = 0
    
    @IBOutlet weak var nyheterTableView: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNews()
        getEvents()
        
        navBarItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ukmStar"))
        navBarItem.titleView?.isUserInteractionEnabled = true
        
        let rightNavItemLogo = UIBarButtonItem(image: #imageLiteral(resourceName: "settingsIcon"), style: .plain, target: self, action: #selector(goToSettings))
            navBarItem.setRightBarButton(rightNavItemLogo, animated: true)
        
        
        var listFix = Event()
        listFix.eventDescription = ""
        listFix.date = "2016-10-07 20:00:00.000000"
        listFix.dateFile = listFix.stringToDate(dateString: listFix.date)
        listFix.id = 0
        listFix.name = "Used to fix shit"
        listFix.place = "Nowhere"
        listFix.spotsLeft = 2
        
        arrangList.append(listFix)
        
        
        
    }

    
    @objc func goToSettings(){
        let mainSB = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC") as! SettingsVC
        
        
        mainSB.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        self.present(mainSB, animated: true)
    }
    
    
  
    func getEvents(){
        
        var eventDownloadCounter = 0
        let url = "https://rsvp.ukm.no/api/events/place-4920/json/" //"https://rsvp.ukm.no/api/events/all/json/" 
        var imageFailure: Int = 0
        
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.value != nil{
                
                let swiftJson = JSON(response.result.value!)
                
                for eventJson in swiftJson.array!{
                    var event = Event()
                    event.id = eventJson["id"].int
                    event.name = eventJson["name"].string
                    event.place = eventJson["place"].string
                    event.spotsLeft = eventJson["spots"].int
                    event.eventDescription = eventJson["description"].string
                    event.date = eventJson["date_start"]["date"].string
                    event.dateFile = event.stringToDate(dateString: event.date)

                    
                    if eventJson["image"].string != ""{
                        event.imageLink = eventJson["image"].string
                        
                        Alamofire.request(event.imageLink!).responseImage(completionHandler: { (response) in
                            
                            
                            if response.result.value != nil{
                                
                                let t = UIImage(data: response.data!)
                                event.imageFile = t
                                
                                self.arrangList.append(event)
                                
                                
                                if (swiftJson.array?.count)! == self.arrangList.count{
                                    
                                    StoredData.currentSession.eventList = self.arrangList
                                    
                                    DispatchQueue.main.async {
                                        self.nyheterTableView.reloadData()
                                    }
                                }
                                
                            }else{
                                print(response.error!.localizedDescription)
                                self.arrangList.append(event)
                                
                                
                                // NOTE - Om et bilde ikke er kompitabelt med alamoImage så vil det ikke bli lagt til i listen
                                
                            }
                            
                        })
                        
                    }else{
                        
                        print("API count: " + String(swiftJson.array!.count))
                        print(event.name)
                        self.arrangList.append(event)
                        print(self.arrangList.count)

                        
                        if (swiftJson.array?.count)! + 1 == self.arrangList.count{
                            
                            StoredData.currentSession.eventList = self.arrangList
                            
                            DispatchQueue.main.async {
                                self.nyheterTableView.reloadData()
                            }
                            
                        }
                        
                    }
                    
                }
                if (swiftJson.array?.count)! == self.arrangList.count{
                    
                    StoredData.currentSession.eventList = self.arrangList
                    
                    DispatchQueue.main.async {
                        self.nyheterTableView.reloadData()
                    }
                }
                
            }else{return}
            
        }
        
    }
    
    
    func getNews(){
        
        let url = "https://ukm.no/rakkestad/category/nyheter/?exportContent=true"
        
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.value != nil{
                
                let swiftJson = JSON(response.result.value!)
                
                for article in swiftJson.array!{
                    var thisArticle = NewsArticle()
                    
                    thisArticle.title = article["title"].string
                    thisArticle.imageLink = article["image"]["medium"]["src"].string
                    thisArticle.dateWritten = article["date"].string
                    thisArticle.url = article["url"].string
                    thisArticle.dateFile = thisArticle.stringToDate(dateString: thisArticle.dateWritten)
                    
                    
                    //Get the image async, then update the image
                    Alamofire.request(thisArticle.imageLink).responseImage(completionHandler: { (response) in
                        
                        if response.result.value != nil{
                           
                            let t = UIImage(data: response.data!)
                            
                            thisArticle.image = t
                            
                            DispatchQueue.main.async {
                                self.nyheterTableView.reloadData()
                            }
                            
                        }else{
                            print(response.error)
                            
                        }
                        
                    })
                    
                    self.nyhetList.append(thisArticle)
                   
                    
                    
                    if swiftJson.array?.count == self.nyhetList.count{
                        
                        StoredData.currentSession.newsList = self.nyhetList
                        
                        DispatchQueue.main.async {
                            self.nyheterTableView.reloadData()
                        }
                    }
                    
                }
                
                
            }else{return}
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrangList.count + 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return 60
            break
        case 1:
            return 270
            break
        case 2:
            return 60
            break
        case 3:
            
            break
        default:
            return 65
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.row {
            
        case 0:
            //Headercell Nyheter
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.headerName.text = "Nyheter"
            cell.headerAllName.text = ""
            
            return cell
            
        case 1:
           //NyhetCollectionview
            let cell = tableView.dequeueReusableCell(withIdentifier: "nyhetCell") as! NyhetCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.nyhetColView.dataSource = self
            cell.nyhetColView.delegate = self
            
            cell.nyhetColView.reloadData()
            
            return cell
            
        case 2:
            //Headercell arrang
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.headerName.text = "Arrangementer"
            cell.headerAllName.text = ""
            
            return cell
            
        default:
            //Arrangcell
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "arrangCell") as! ArrangementCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let indexFix = indexPath.row - 3
            
            cell.arrangTitle.text = arrangList[indexFix].name
            cell.arrangTimeLabel.text = arrangList[indexFix].dateFile.getDateAndMonthName()
            cell.arrangSpotsLabel.text = "Plasser igjen: " + String(describing: arrangList[indexFix].spotsLeft!)
            
            
            if arrangList[indexFix].imageFile != nil{
                
                cell.arrangImage.image = arrangList[indexFix].imageFile
            }
            
            if indexPath.row == arrangList.count - 1{
                
            }
            

            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < 3{
            return
        }
        
        objectTosend = arrangList[indexPath.row - 3]
        performSegue(withIdentifier: "segueToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToDetail"{
            
            let detailVC: EventDetails = segue.destination as! EventDetails
            
            if let tt = objectTosend as? NewsArticle{
                
                detailVC.thisArticle = objectTosend as! NewsArticle
                
            }else{
                
                detailVC.thisEvent = objectTosend as! Event
                
            }
        }
        if segue.identifier == "segueToNewsDetails"{
            
            let newsDetailsVC: NewsWebViewVC = segue.destination as! NewsWebViewVC
            
            newsDetailsVC.thisNewsArticle = objectTosend as! NewsArticle
        }
        
        if segue.identifier == "segueToSettings"{
            let settingsVC: SettingsVC = segue.destination as! SettingsVC
            
            settingsVC.getUserSettings()
        }
        
        
    }

}









extension NyheterVC: UICollectionViewDelegate,UICollectionViewDataSource{
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return nyhetList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nyhetColCell", for: indexPath) as! NyhetColCell
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.nyhetImage.image = nyhetList[indexPath.row].image
        cell.nyhetTimeWritten.text = "Skrevet: " + nyhetList[indexPath.row].dateFile.getNumericalDate()
        cell.nyhetTitle.text = nyhetList[indexPath.row].title
        
        if nyhetList[indexPath.row].image != nil {
            cell.nyhetImage.image = nyhetList[indexPath.row].image
        }
       
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        objectTosend = nyhetList[indexPath.row]
        performSegue(withIdentifier: "segueToNewsDetails", sender: self)
    }
    
}




