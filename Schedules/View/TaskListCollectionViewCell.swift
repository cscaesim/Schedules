//
//  TaskListTableViewCell.swift
//  Schedules
//
//  Created by Caine Simpson on 11/19/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit

class TaskListCollectionViewCell: UICollectionViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = UIColor.black
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
}
