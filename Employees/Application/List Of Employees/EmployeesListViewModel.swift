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
    //var localContactsNames: [String]? { get }
    var showContactsAlert:(() -> Void)? { get set }
    
    var employeesListUpdated: (() -> Void)? { get set }
    var localContactsListUpdated: (() -> Void)? { get set }
    var errorOccured: (() -> Void)? { get set }
    
    func downloadEmployees()
    //func employeesWithPosition(positionSection: Int) -> [Employee]?
    func employeesWithPosition(positionSection: Int, isSearchActive: Bool) -> [Employee]?
     func filterEmployeesMatching(text: String?)
    
    //func isEmployeeInLocalContacts(employee: Employee) -> Bool
//    func localContact(fullName: String) -> CNContact?
//    func fetchLocalContacts()
    
   
}
