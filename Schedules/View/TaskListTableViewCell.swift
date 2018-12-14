//
//  TaskListTableViewCell.swift
//  Schedules
//
//  Created by Caine Simpson on 12/14/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit

class TaskListTableViewCell : UITableViewCell {
    
//    var task : Task? {
//        didSet {
//            task?.name = task?.name
//            task?.time = task?.time
//            task.completed = task?.completed
//        }
//    }
    
    let taskNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(taskNameLabel)
        addSubview(dateLabel)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        taskNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: frame.size.width - 80, height: 0, enableInsets: false)
        dateLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: frame.size.width / 2, height: 15, enableInsets: false)
    }
}
