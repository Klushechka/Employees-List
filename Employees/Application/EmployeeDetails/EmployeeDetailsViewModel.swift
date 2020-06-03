//
//  EmployeeDetailsViewModel.swift
//  Employees
//
//  Created by Olga Kliushkina on 31.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

protocol EmployeeDetailsViewModel {
    init(with employee: Employee)
    
    var employee: Employee { get }
    var showLocalContactButton: Bool { get }
    
    var errorOccured: (() -> Void)? { get set }
}
