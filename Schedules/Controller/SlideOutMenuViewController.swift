//
//  SlideOutMenuViewController.swift
//  Schedules
//
//  Created by Caine Simpson on 11/11/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit
//import CoreData

class SlideOutMenuViewController: UIViewController {
    
    let fullView: CGFloat = UIScreen.main.bounds.height * 0.50
    
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 100
    }
    
    let layout = UICollectionViewFlowLayout()
    
    var viewController: HomeViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.createButton.addTarget(self, action: #selector(createScheduleButtonPressed), for: .touchUpInside)
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(SlideOutMenuViewController.panGesture))
        view.addGestureRecognizer(gesture)
        
        viewController = HomeViewController(collectionViewLayout: layout)
        
    }
    
    @objc func createScheduleButtonPressed() {
        print("Button pressed")
        
        guard let title = titleTextField.text,
            let name = titleTextField.text else {
                return
        }
        
        viewController.save(name: name)
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
        print("Sent notification")
        

    }

    
    weak var slideOutMenu: SlideOutCreationMenu! {return self.view as! SlideOutCreationMenu}
    weak var createButton: UIButton! {return slideOutMenu.addButton}
    weak var titleTextField: UITextField! {return slideOutMenu.titleTextField}
    
    override func loadView() {
        self.view = SlideOutCreationMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 100
            self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
        }
    }
    

}


extension SlideOutMenuViewController {
    func prepareBackground() {
        
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        
        bluredView.contentView.addSubview(visualEffect)
    
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: nil)
        }
    }
}
