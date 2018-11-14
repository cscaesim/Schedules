//
//  ScheduleCollectionViewCell.swift
//  Schedules
//
//  Created by Caine Simpson on 11/10/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
    
    var randomColors = [UIColor.init(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0),
                        UIColor.init(red: 76/255, green: 75/255, blue: 150/255, alpha: 1.0),
                        UIColor.init(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0),
                        UIColor.init(red: 103/255, green: 58/255, blue: 183/255, alpha: 1.0)]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        self.layer.shadowRadius = 1.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        addSubview(nameLabel)
        
        self.backgroundColor = randomColors[1]
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Test"
        lb.font = UIFont(name: "HelveticaNeue-Bold", size: 32)
        lb.textColor = UIColor.white
        return lb
    }()
    
    
    func setupViews() {
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 20)
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
