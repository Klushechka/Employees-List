//
//  UITableVIew+Extension.swift
//  Employees
//
//  Created by Olga Kliushkina on 28.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func showPlaceholder(message: String) {
        guard let view = self.superview else { return }
        
        let rect = CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: view.frame.size.width, height: view.frame.size.height))
        
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func hidePlaceholder() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
