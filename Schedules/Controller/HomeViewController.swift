//
//  ViewController.swift
//  Schedules
//
//  Created by Caine Simpson on 11/8/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit
import CoreData


var randomColors = [UIColor.init(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0),
                    UIColor.init(red: 76/255, green: 75/255, blue: 150/255, alpha: 1.0),
                    UIColor.init(red: 255/255, green: 152/255, blue: 0/255, alpha: 1.0),
                    UIColor.init(red: 103/255, green: 58/255, blue: 183/255, alpha: 1.0)]

class HomeViewController: UICollectionViewController {
    
    private var cellId = "cellID"
    
    var schedules: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfEmpty()
        
        
        print("View did load")
        
        for object in schedules {
            print(object)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: NSNotification.Name("reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let panCellGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(panCell))
        panCellGesture.delegate = self
        self.collectionView.addGestureRecognizer(panCellGesture)
        
        navigationItem.title = "Schedules"
        navigationController?.navigationBar.barTintColor = randomColors[0]
        navigationController?.navigationBar.barStyle = .black
        
        
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.backgroundColor = UIColor.init(red: 230/255, green: 233/255, blue: 239/255, alpha: 1.2)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = nil
        
        resetTableData()
        
        checkIfEmpty()
        
        collectionView.reloadData()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSlideOutMenu()
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Schedule")
        
        do {
            schedules = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("\(error),\(error.userInfo)")
        }
        
        collectionView.reloadData()
        checkIfEmpty()
    }
    
    public func save(name: String) {
        print("This get called")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Schedule", in: managedContext)!
        //let entity = NSEntityDescription.insertNewObject(forEntityName: "Schedule", into: managedContext)
        
        let schedule = NSManagedObject(entity: entity, insertInto: managedContext)
        
        schedule.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            schedules.append(schedule)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func delete(path: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Schedule")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[path] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error )
        }
        
        resetTableData()
    }
    
    func checkIfEmpty() {
        if schedules.isEmpty {
            collectionView.setEmptyMessage()
        } else {
            collectionView.restore()
        }
    }
    
    @objc func panCell() {
        
    }
    
    func deleteCell() {
        
    }
}

extension HomeViewController {
    @objc func keyboardWillShow(notification:NSNotification) {
        print("keyboard shown")
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        print("Keyboard dismissed")
        
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
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScheduleCollectionViewCell
        let schedule = schedules[indexPath.row]
        cell.nameLabel.text = schedule.value(forKeyPath: "name") as? String
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        print("supposed to delete \(indexPath.row)")
        let schedule = schedules[indexPath.row]
        let name = schedule.value(forKey: "name") as? String
        delete(path: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
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

extension UICollectionView {
    
    func setEmptyMessage() {
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = "You currently have no schedules created! Why not create one?"
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.black
        messageLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
