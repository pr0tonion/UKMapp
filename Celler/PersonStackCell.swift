//
//  PersonStackCell.swift
//  UKM
//
//  Created by Marcus Pedersen on 12.05.2018.
//  Copyright © 2018 Marcus Pedersen. All rights reserved.
//

import UIKit

class PersonStackCell: UIView {

    var name: String = ""
    var age: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func setupViews(){
        self.addSubview(contentView)
        self.addSubview(deleteBtn)
        
    }
    
    func setupConstraints(){
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        
        deleteBtn.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        deleteBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
    }
    
    
    let contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1
        
        return view
        
    }()
    
    let deleteBtn: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Slett", for: .normal)
        button.titleLabel?.textColor = UIColor.purple
        return button
        
    }()

    
}
