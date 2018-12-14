//
//  TaskListViewController.swift
//  Schedules
//
//  Created by Caine Simpson on 11/19/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit
//import CoreData

class TaskListViewController: UICollectionViewController {
    
    //let tasks = [Task]()
    let reuseId = "reuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = scheduleName
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTask))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(handleBack))
        
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        collectionView.layoutMargins.top = 20
        collectionView.register(TaskListCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        
        collectionView.backgroundColor = UIColor.init(red: 230/255, green: 233/255, blue: 239/255, alpha: 1.2)
        
        loadData()

    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        
    }
    
    @objc func createTask() {
        let createTaskController = CreateTaskViewController()
        navigationController?.pushViewController(createTaskController, animated: true)
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }

}
