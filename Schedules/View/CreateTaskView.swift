//
//  CreateTaskView.swift
//  Schedules
//
//  Created by Caine Simpson on 11/11/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit

class CreateTaskView: UIView {
    
    var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 5.0
        view.layer.masksToBounds = true
        //view.backgroundColor = UIColor.blue
        
        
        return view
    }()
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.text = "Enter title here"
        return label
    }()
    
    let titleTextField : UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        //        textField.placeholder = "Create Schedule"
        //        textField.borderStyle = .roundedRect
        //        textField.borderStyle = UITextField.BorderStyle.none
        textField.text = "Title"
        textField.isEditable = true
        textField.font = UIFont(name: "HelveticaNeue", size: 18)
        textField.textColor = UIColor.lightGray
        textField.backgroundColor = UIColor.white
        textField.scrollsToTop = true
        return textField
    }()
    
    let createButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Click Me", for: UIControl.State.normal)
        button.backgroundColor = UIColor.blue
        
        
        return button
    }()
    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.timeZone = NSTimeZone.local
        picker.backgroundColor = UIColor.white
        return picker
    }()
    
    let notificationToggle : UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.backgroundColor = UIColor.white
        switcher.layoutMargins.top = 50
        return switcher
    }()
    
    let reminderLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "  Enable Reminder"
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.backgroundColor = UIColor.white
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 230/255, green: 233/255, blue: 239/255, alpha: 1.2)
        
        addSubview(titleTextField)
        addSubview(datePicker)
        addSubview(notificationToggle)
        addSubview(reminderLabel)
        addSubview(createButton)
        
        
        setupViews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        let reminderHeight: CGFloat = 32
        
        //noteTextField
        titleTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 70).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        //notification label
        reminderLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 35).isActive = true
        reminderLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        reminderLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -50).isActive = true
        reminderLabel.heightAnchor.constraint(equalToConstant: reminderHeight).isActive = true
        
        //notification toggle
        notificationToggle.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 35).isActive = true
        notificationToggle.leftAnchor.constraint(equalTo: reminderLabel.rightAnchor).isActive = true
        notificationToggle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        notificationToggle.heightAnchor.constraint(equalToConstant: reminderHeight).isActive = true
        
        //date picker
        datePicker.topAnchor.constraint(equalTo: notificationToggle.bottomAnchor, constant: 10).isActive = true
        datePicker.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //Create button
        //createButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 100).isActive = true
        createButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        createButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}


