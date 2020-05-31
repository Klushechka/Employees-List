//
//  EmployeeDetailsViewModelImpl.swift
//  Employees
//
//  Created by Olga Kliushkina on 31.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

final class EmployeeDetailsViewModelImpl: EmployeeDetailsViewModel {
    
    var employee: Employee
    
    init(with employee: Employee) {
        self.employee = employee
    }
    
}
