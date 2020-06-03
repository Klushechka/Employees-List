//
//  LocalContactsViewModel.swift
//  Employees
//
//  Created by Olga Kliushkina on 01.06.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import Contacts

protocol LocalContactsViewModel {
    var localContactsService: LocalContactsService? { get }
    var localContactsNames: [String]? { get }
    var localContactsListUpdated: (() -> Void)? { get set }
    
    func isEmployeeInLocalContacts(employee: Employee) -> Bool
    func localContact(fullName: String) -> CNContact?
    func fetchLocalContacts()
}
