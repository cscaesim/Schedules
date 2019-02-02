//
//  TaskListViewController.swift
//  Schedules
//
//  Created by Caine Simpson on 11/19/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit
import RealmSwift



class TaskListViewController: UITableViewController {
    
    var tasks = [Task]()
    let reuseId = "reuseId"
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
        
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = scheduleName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTask))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(handleBack))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: reuseId)
        
        loadData()
        tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        let name = scheduleName!
        
        let schedules = realm.objects(Schedule.self).sorted(by: ["name"])
        
        if let schedule = schedules.filter({$0.name == name}).first {
            print(schedule)
            tasks = Array(schedule.tasks)
            
            print(schedule.tasks)
            
        } else {
            print("Not working")
        }
    }
    
    @objc func createTask() {
        let createTaskController = CreateTaskViewController()
        navigationController?.pushViewController(createTaskController, animated: true)
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId) as! TaskListTableViewCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].name
        let date = 
        cell.dateLabel.text = tasks[indexPath.row].time
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}



extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType != .none {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
            let schedules = realm.objects(Schedule.self).sorted(by: ["name"])
            
            if let schedule = schedules.filter({$0.name == scheduleName}).first {
                do {
                    try! realm.write {
                        schedule.tasks.remove(at: indexPath.row)
                    }
                } catch let error {
                    print(error)
                }
            }
            tableView.reloadData()
        }
    }
}
