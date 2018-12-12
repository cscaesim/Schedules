//
//  ScheduleCollectionViewCell.swift
//  Schedules
//
//  Created by Caine Simpson on 11/10/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var pan: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        self.layer.cornerRadius = 20
//        self.layer.masksToBounds = false
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        self.layer.shadowRadius = 1.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        
        addSubview(nameLabel)
        addSubview(countLabel)
        self.insertSubview(deleteLabel, belowSubview: self.contentView)
        
        self.contentView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.red
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        pan.cancelsTouchesInView = false
        self.addGestureRecognizer(pan)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
    }
    
    let nameLabel : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Test"
        lb.font = UIFont(name: "HelveticaNeue", size: 24)
        //lb.textColor = UIColor.white
        return lb
    }()
    
    let deleteLabel : UILabel = {
        let label = UILabel()
        label.text = "Delete"
        label.textColor = UIColor.white
        
        return label
    }()
    
    let countLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "0"
        lb.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        lb.textColor = UIColor.lightGray
        return lb
    }()
    
    
    func setupViews() {
        //Title label
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
//      nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 20)
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        //Count label
        countLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        countLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        countLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //countLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 5).isActive = true
        
        
        //Setup delete label hidden underneath
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizer.State.changed) {
            let velocity: CGPoint = pan.velocity(in: self.contentView)
            if velocity.x < 0 {
                countLabel.isHidden = true
                let p: CGPoint = pan.translation(in: self)
                let width = self.contentView.frame.width
                let height = self.contentView.frame.height
                self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
                //self.deleteLabel.frame = CGRect(x: p.x - deleteLabel.frame.size.width-10, y: 0, width: 100, height: height)
                self.deleteLabel.frame = CGRect(x: p.x + width + deleteLabel.frame.size.width, y: 0, width: 100, height: height)
            } else {
                countLabel.isHidden = false
            }
        } else {
            countLabel.isHidden = false
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {
            
        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
    
}
