//
//  Task.swift
//  Schedules
//
//  Created by Caine Simpson on 11/11/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import Foundation

class Task {
    var taskDescription: String
    var reminderSet: Bool
    var reminderTime : NSDate
    
    init(taskD : String, reminderSet: Bool, reminderTime: NSDate) {
        self.taskDescription = taskD
        self.reminderSet = reminderSet
        self.reminderTime = reminderTime
    }
}
