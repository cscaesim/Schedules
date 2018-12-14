//
//  CreateTaskViewController.swift
//  Schedules
//
//  Created by Caine Simpson on 11/11/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class CreateTaskViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    
    var tap: UIGestureRecognizer!
    
    var currentSchedule: Schedule?
    var realm: Realm!

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        navigationItem.title = "New Task"
        
        guard let schedule = scheduleName else {
            return
        }
        //print(schedule)
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        print(realm)
        view.addGestureRecognizer(tap)
        
        self.createTaskButton.addTarget(self, action: #selector(createTask), for: .touchUpInside)
        
        //if !schedule.isEmpty {
        let schedules = realm.objects(Schedule.self).sorted(by: ["name"])
        //filter("name == \(schedule)").first
        if let currentSchedule = schedules.filter({$0.name == schedule}).first {
            print(currentSchedule)
        } else {
            print("There are no Schedules")
        }
        

    }
    
    override func loadView() {
        self.view = CreateTaskView()
    }
    
    
    @objc func createTask() {
        checkForNotificationStatus()
        
        let title = "Schedules"
        let date = datePicker.date
        guard let task = titleTextField.text else {
            return
        }
        
        
        
        createNotification(title: title, task: task, date: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let stringDate = dateFormatter.string(from: date)
        
        let newTask = Task()
        newTask.name = task
        newTask.completed = false
        newTask.time = stringDate
        
        
        
        var tasks = currentSchedule!.tasks
    
        
        try! realm.write {
            currentSchedule!.tasks = tasks
        }
       
    }
    
    func createNotification(title: String, task: String, date: Date) {
        let title = "Schedules"
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .minute], from: date)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = task
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "SchedulesNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func checkForNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("Notifications authorized")
                
            } else {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                    print("granted: \(granted)")
                }
            }
        }
    }
    
    weak var createTaskView: CreateTaskView! {return self.view as! CreateTaskView}
    weak var titleTextField: UITextView! { return createTaskView.titleTextField}
    weak var datePicker: UIDatePicker! { return createTaskView.datePicker}
    weak var notificationToggle: UISwitch! {return createTaskView.notificationToggle }
    weak var createTaskButton: UIButton! { return createTaskView.createButton }
}

extension CreateTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (titleTextField.text == "Title") {
            titleTextField.text = nil
            titleTextField.text = ""
            titleTextField.textColor = UIColor.black
        }
        
        titleTextField.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleTextField.text.isEmpty {
            titleTextField.text = "Title"
            titleTextField.textColor = UIColor.lightGray
            
        }
        
        titleTextField.resignFirstResponder()
    }
}

extension CreateTaskViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
