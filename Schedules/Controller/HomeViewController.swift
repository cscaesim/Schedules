//
//  ViewController.swift
//  Schedules
//
//  Created by Caine Simpson on 11/8/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit
import RealmSwift


var scheduleName: String!

class HomeViewController: UICollectionViewController {
    
    private var cellId = "cellID"
    
    var schedules = [Schedule]()
    var realm : Realm!
    
    var tap: UIGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        
        realm = try! Realm()
        checkIfEmpty()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: NSNotification.Name("reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let result = realm.objects(Schedule.self)
        
        schedules = Array(result)

        
        //Gesture for swipe to delete
        let panCellGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(panCell))
        panCellGesture.delegate = self
        self.collectionView.addGestureRecognizer(panCellGesture)
        
        navigationItem.title = "Schedules"
        navigationController?.navigationBar.barTintColor = randomColors[0]
        navigationController?.navigationBar.barStyle = .black
        
        collectionView.backgroundColor = UIColor.init(red: 230/255, green: 233/255, blue: 239/255, alpha: 1.2)
        
        addSlideOutMenu()

    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = nil
        
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: cellId)

        resetTableData()

        checkIfEmpty()
        
        collectionView.reloadData()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func reloadData(notification: NSNotification) {
        print("got Notification")
        
        DispatchQueue.main.async {
            print("reload data")
            self.resetTableData()
        }
        
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
        
        
    }

    
    func resetTableData() {
        realm = try! Realm()
        
        let results = realm.objects(Schedule.self)
        schedules = Array(results)
        print(results)
        
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
//
        OperationQueue.main.addOperation {
            self.collectionView.reloadData()
        }
        
        checkIfEmpty()
    }
    
    public func save(name: String) {
        print("This get called")
        
        let newSchedule = Schedule()
        
        newSchedule.name = name
        
        let realm = try! Realm()
        
        schedules.append(newSchedule)
        
        try! realm.write {
            realm.add(newSchedule)
            collectionView.reloadData()
        }

        print("New Schedule created with name: \(name)")
        
        
    }
    
    func checkIfEmpty() {
        if schedules.isEmpty {
       
            self.collectionView.setEmptyMessage()
            
        } else {

            self.collectionView.restore()
            
        }
    }
    
    @objc func panCell() {
        
    }
    
    func removeGesture() {
        print("removing tap gesture for keyboard")
        view.removeGestureRecognizer(tap)
    }
    
    func addGesture() {
        view.addGestureRecognizer(tap)
        print("Adding tap gesture for keyboard")
    }
    
}

extension HomeViewController {
    @objc func keyboardWillShow(notification:NSNotification) {
        print("keyboard shown")
        addGesture()
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        print("Keyboard dismissed")
        removeGesture()
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Did select row:\(indexPath.row)")
        let schedule = schedules[indexPath.row]
        
        guard let name = schedule.value(forKey: "name") as? String else {
            return
        }
        scheduleName = name
        print(scheduleName)
        let taskViewController = TaskListViewController(style: .plain)
        navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScheduleCollectionViewCell
        let schedule = schedules[indexPath.row]
        cell.nameLabel.text = schedule.name
        cell.countLabel.text = String(schedule.tasks.count)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        print("supposed to delete \(indexPath.row)")
        //let schedule = schedules[indexPath.row]
        
        let item = schedules[indexPath.row]
        schedules.remove(at: indexPath.row)
        collectionView.reloadData()
    
        try! self.realm.write {
            self.realm.delete(item)

        }

        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
}



extension HomeViewController {
    
    func addSlideOutMenu() {
        let bottomViewVC = SlideOutMenuViewController()

        self.addChild(bottomViewVC)
        self.view.addSubview(bottomViewVC.view)
        bottomViewVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        
        bottomViewVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
}

extension HomeViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //IF FALSE DISABLED COLLECTIONVIEW VERTICAL SCROLLING
        return true
    }
}


