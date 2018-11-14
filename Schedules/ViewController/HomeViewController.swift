//
//  ViewController.swift
//  Schedules
//
//  Created by Caine Simpson on 11/8/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UICollectionViewController {
    
    private var cellId = "cellID"
    
    var schedules: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: NSNotification.Name("reload"), object: nil)
        
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        self.view.backgroundColor = UIColor.white
        collectionView.backgroundColor = UIColor.white
        
        print(schedules.count)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = nil
        
        resetTableData()
        
        if schedules.isEmpty {
            collectionView.setEmptyMessage()
        } else {
            collectionView.restore()
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 10, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5.0, bottom: 0.0, right: 0.0)
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
