//
//  EmployeesListViewModel.swift
//  Employees
//
//  Created by Olga Kliushkina on 29.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import UIKit

protocol EmployeesListViewModel {
    func downloadEmployees()
    func employeesWithPosition(positionSection: Int) -> [Employee]?
    
    var employees: [Employee]? { get }
    var positions: [String?]? { get }
    
    var dataUpdated: (() -> Void)? { get set }
    var errorOccured: (() -> Void)? { get set }
}
