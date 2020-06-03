//
//  UIViewController+Extensions.swift
//  Employees
//
//  Created by Olga Kliushkina on 29.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showDefaultStyleAlert(title: String, message: String, buttonLabel: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonLabel, style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}
