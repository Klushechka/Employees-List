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
    
    func showDefaultAlert(title: String, message: String, buttonLabel: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonLabel, style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showContactsSettingsAlert() {
        let alert = UIAlertController(title: AlertConstants.contactsTitle, message: AlertConstants.contactsDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        
        alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel))
        
        present(alert, animated: true)
    }
    
}
