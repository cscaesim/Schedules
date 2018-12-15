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
        
        UNUserNotificationCenter.current().delegate = self
        
        navigationItem.title = "New Task"
        
        guard let schedule = scheduleName else {
            return
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        notificationToggle.addTarget(self, action: #selector(toggleValueDidChange), for: .valueChanged)
        
        //print(realm)
        view.addGestureRecognizer(tap)
        
        self.createTaskButton.addTarget(self, action: #selector(createTask), for: .touchUpInside)
        
        
        
    }
    
    
    override func loadView() {
        self.view = CreateTaskView()
    }
    
    @objc func toggleValueDidChange(sender: UISwitch) {
        print(sender.isOn)
    }
    
    @objc func createTask() {
        checkForNotificationStatus()
        
        guard let title = scheduleName else {
            return
        }
        
        guard let task = titleTextField.text else {
            return
        }
        
        let date = datePicker.date
        let notificationEnabled = notificationToggle.isOn
        
        //if notificationEnabled == true {
            createNotification(title: title, task: task, date: date)
        //}
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let stringDate = dateFormatter.string(from: date)
        
        let newTask = Task()
        newTask.name = task
        newTask.completed = false
        newTask.time = stringDate
        
        
        let schedules = realm.objects(Schedule.self).sorted(by: ["name"])
        if let currentSchedule = schedules.filter({$0.name == title}).first {
            do {
                try! realm.write {
                    currentSchedule.tasks.append(newTask)
                }
            } catch let error {
                print(error)
            }
        } else {
            print("There are no Schedules")
        }
        
        dismiss(animated: true, completion: nil)
       
    }
    
    func createNotification(title: String, task: String, date: Date) {
        print("Notification being created")
        let title = "Schedules"
        let triggerDate = Calendar.current.dateComponents([.month, .day, .minute], from: date)
        var components = DateComponents()
        //print(triggerDate)
        
        //components.year = triggerDate.year
        components.month = triggerDate.month
        components.day = triggerDate.day
        components.minute = triggerDate.minute
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = task
        content.sound = UNNotificationSound.default
        
        print(components)
        
        
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        //let trigger = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "SchedulesNotification", content: content, trigger: trigger)
        
        
        
        //UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            } else {
                print("Making Notification successful")
            }
        }
        
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
