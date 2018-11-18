//
//  ScheduleCollectionViewCell.swift
//  Schedules
//
//  Created by Caine Simpson on 11/10/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        self.layer.cornerRadius = 20
//        self.layer.masksToBounds = false
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        self.layer.shadowRadius = 1.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        addSubview(nameLabel)
        addSubview(countLabel)
        
        self.backgroundColor = UIColor.white
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Test"
        lb.font = UIFont(name: "HelveticaNeue", size: 24)
        //lb.textColor = UIColor.white
        return lb
    }()
    
    let countLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "0"
        lb.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        lb.textColor = UIColor.lightGray
        return lb
    }()
    
    
    func setupViews() {
        //Title label
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
//      nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 20)
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        //Count label
        countLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        countLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        countLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //countLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 5).isActive = true
        
    }
    
}
