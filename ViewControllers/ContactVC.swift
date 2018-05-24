//
//  ContactVC.swift
//  UKM
//
//  Created by Marcus Pedersen on 01.05.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class ContactVC: UIViewController {

    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var tappedCellPerson: ContactPerson?
    var contactList:[ContactPerson] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        let Kristin: ContactPerson = ContactPerson()
        Kristin.eMail = "Krstin@ukm.no"
        Kristin.name = "Kristin et eller annet"
        Kristin.phoneNumber = "12345678"
        Kristin.profilePicture = #imageLiteral(resourceName: "testphoto")
        
        contactList.append(Kristin)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareView(){
        navBarItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ukmStar"))
        navBarItem.titleView?.isUserInteractionEnabled = true
        
        //navBarItem.titleView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeCachedData)))
        let rightNavItemLogo = UIBarButtonItem(image: #imageLiteral(resourceName: "settingsIcon"), style: .plain, target: self, action: #selector(goToSettings))
        navBarItem.setRightBarButton(rightNavItemLogo, animated: true)
    }

    @objc func goToSettings(){
        let mainSB = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingsVC") as! SettingsVC
        
        
        mainSB.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        self.present(mainSB, animated: true)
    }

}

extension ContactVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(callContact))
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(emailContact))
        
        let contactPerson = contactList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactTableViewCell
        
        cell.contentView.bringSubview(toFront: cell.phoneImage)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.contactImage.image = contactPerson.profilePicture
        cell.eMailLabel.text = contactPerson.eMail
        cell.phoneLabel.text = contactPerson.phoneNumber
        cell.nameLabel.text = contactPerson.name
        
        cell.phoneImage.addGestureRecognizer(phoneTap)
        cell.mailImage.addGestureRecognizer(emailTap)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedCellPerson = contactList[indexPath.row]
    }
    
    @objc func callContact(number: String){
        
        var number = tappedCellPerson
        print(tappedCellPerson?.phoneNumber)
        
    }
    
    @objc func emailContact(){
        
    }
  
}

class ContactTableViewCell: UITableViewCell{
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var mailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var eMailLabel: UILabel!
    
}
