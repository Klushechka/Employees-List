//
//  EmployeesListViewModel.swift
//  Employees
//
//  Created by Olga Kliushkina on 29.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import UIKit
import Contacts

protocol EmployeesListViewModel {
    func downloadEmployees()
    func employeesWithPosition(positionSection: Int) -> [Employee]?
    func employeeIsInDeviceContacts(employee: Employee) -> Bool
    
    func deviceContact(fullName: String) -> CNContact?
    func fetchDeviceContacts()
    
    var employees: [Employee]? { get }
    var positions: [String?]? { get }
    var deviceContactsNames: [String]? { get }
    
    var isOpenDeviceContactsButtonNeeded: Bool { get }
    var showContactsAlert:(() -> Void)? { get set }
    
    var dataUpdated: (() -> Void)? { get set }
    var errorOccured: (() -> Void)? { get set }
}
