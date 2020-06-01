//
//  EmployeeDetailsViewModelImpl.swift
//  Employees
//
//  Created by Olga Kliushkina on 31.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import Contacts

final class EmployeeDetailsViewModelImpl: EmployeeDetailsViewModel, LocalContactsViewModel {
    
    var employee: Employee
    
    var localContactsService: LocalContactsService?
    
    var localContactsNames: [String]? {
        didSet {
            if self.localContactsNames != oldValue {
                self.localContactsListUpdated?()
            }
        }
    }
    
    var localContactsListUpdated: (() -> Void)?
    
    var showLocalContactButton: Bool {
        return isEmployeeInLocalContacts(employee: self.employee)
    }
    
    init(with employee: Employee) {
        self.employee = employee
        
        fetchLocalContacts()
    }
    
    func isEmployeeInLocalContacts(employee: Employee) -> Bool {
        guard let localContactsNames = self.localContactsNames else { return false }
         
         let fullName = String("\(employee.name) \(employee.surname)").lowercased()
         
         return localContactsNames.contains(fullName)
    }
    
    func localContact(fullName: String) -> CNContact? {
        guard let localContactsService = self.localContactsService, let localContact = localContactsService.contact(with: fullName) else {
//            self.errorOccured?()
            return nil
        }
        
        return localContact
    }
    
    func fetchLocalContacts() {
        self.localContactsService = LocalContactsService()
        
        guard let localContactsService = self.localContactsService else { return }
        
        self.localContactsNames = localContactsService.localContactsNames()
        
        localContactsService.permissionRequestNeeded = {
//            self.showContactsAlert?()
            
            print ("I NEED PERMISSION!")
        }
    }
    
    
}
