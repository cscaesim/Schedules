//
//  Schedule.swift
//  Schedules
//
//  Created by Caine Simpson on 11/24/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import RealmSwift

class Schedule: Object {
    @objc dynamic var name: String?
    let tasks = List<Task>()
    
}
