//
//  EmployeesListViewModel.swift
//  Employees
//
//  Created by Olga Kliushkina on 29.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import UIKit

protocol EmployeesListViewModel {
    var employees: [Employee]? { get }
    var positions: [String]? { get }
    var employeesMatchingQuery: [Employee]? { get }
    
    var employeesListUpdated: (() -> Void)? { get set }
    var localContactsListUpdated: (() -> Void)? { get set }
    var errorOccured: (() -> Void)? { get set }
    
    func downloadEmployees(completion: (() -> Void)?)
    func employeesWithPosition(positionSection: Int, isSearchActive: Bool) -> [Employee]?
    func filterEmployeesMatching(query: String?)
}
