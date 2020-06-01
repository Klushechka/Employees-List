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

    @IBOutlet weak var openLocalContactsButton: UIButton!
    @IBOutlet weak var nameSurnameLabel: UILabel!
    
    var localContactButtonTapped: (() -> Void)?
    
    @IBAction func localContactButtonTapped(_ sender: Any) {
        localContactButtonTapped?()
    }
    
}
