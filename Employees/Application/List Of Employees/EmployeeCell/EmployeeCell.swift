//
//  EmployeeTableViewCell.swift
//  Employees
//
//  Created by Olga Kliushkina on 31.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    static let identifier = "employeeCell"
    static let nibName = "EmployeeCell"

    @IBOutlet weak var openDeviceContactsButton: UIButton!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    var buttonTapped: (() -> Void)?
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        buttonTapped?()
    }
    
}
