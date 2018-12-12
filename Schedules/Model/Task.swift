//
//  Task.swift
//  Schedules
//
//  Created by Caine Simpson on 11/24/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name: String?
    @objc dynamic var time: NSDate?
    @objc dynamic var completed = false
}
