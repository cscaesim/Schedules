//
//  SlideOutCreationMenu.swift
//  Schedules
//
//  Created by Caine Simpson on 11/11/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import Foundation
import UIKit


class SlideOutCreationMenu : UIView {
    
    let slideOutMenuIndicator: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let titleTextField: UITextField = {
        
        let inputTextField = UITextField()
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.backgroundColor = UIColor.white
        inputTextField.textColor = UIColor.black
        inputTextField.placeholder = "Schedule Name"
        inputTextField.layer.cornerRadius = 5
        inputTextField.textAlignment = .center
        inputTextField.layer.masksToBounds = true
        
        
        return inputTextField
    }()
    
    let addButton : UIButton = {
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
//        button.backgroundColor = UIColor.green
        button.backgroundColor = randomColors[0]
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(slideOutMenuIndicator)
        addSubview(titleTextField)
        addSubview(addButton)
        
        setupIndicator()
        setupTitleLabel()
        setupAddButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupIndicator() {
        slideOutMenuIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        slideOutMenuIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        slideOutMenuIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true
        slideOutMenuIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupTitleLabel() {
        titleTextField.topAnchor.constraint(equalTo: slideOutMenuIndicator.bottomAnchor, constant: 100).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupAddButton() {
        addButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        addButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
