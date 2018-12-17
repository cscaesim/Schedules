//
//  UICollectionView+Extensions.swift
//  Schedules
//
//  Created by Caine Simpson on 12/11/18.
//  Copyright © 2018 caesim. All rights reserved.
//

import Foundation
import UIKit

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
