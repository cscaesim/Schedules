//
//  ScheduleList.swift
//  Schedules
//
//  Created by Caine Simpson on 11/24/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import Foundation
import RealmSwift


class ScheduleList: Object {
    @objc dynamic var name: String?
    
    let schedules = List<Schedule>()
}
