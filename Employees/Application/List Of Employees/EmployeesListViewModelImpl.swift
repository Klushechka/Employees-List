//
//  EmployeesListController.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import Contacts

final class EmployeeListViewModelImpl: EmployeesListViewModel {
    
    var employees: [Employee]? {
        didSet {
            fetchDeviceContacts()
        }
    }
    
    var positions: [String?]? {
        didSet {
            self.dataUpdated?()
        }
    }
    
    var isOpenDeviceContactsButtonNeeded: Bool = false
    
    var deviceContactsService: LocalContactsService?
    
    var deviceContactsNames: [String]? {
        didSet {
            dataUpdated?()
        }
    }
    
    var showContactsAlert:(() -> Void)?
    var dataUpdated: (() -> Void)?
    var errorOccured: (() -> Void)?
    
    private var employeesOperation: EmployeesOperation?
    private var networkManager: NetworkingManager?
    
    init() {
        setUpNetworkManager()
        getEmployees()
        fetchDeviceContacts()
    }
    
    private func setUpNetworkManager() {
        self.networkManager = NetworkingManager()
    }
    
    func getEmployees() {
        if let storedEmployees = fetchStoredEmployees() {
            print("MANAGED TO FETCH EMPLOYEES: \(storedEmployees)")
            self.employees = storedEmployees
            self.setUpPositions()
        }
        
        downloadEmployees()
    }
    
    private func fetchStoredEmployees() -> [Employee]? {
        guard let networkManager = self.networkManager else { return nil }
        
        return networkManager.retrieveData(fileName: .employees, dataType: [Employee].self)
    }
    
    func downloadEmployees() {
        guard let networkManager = self.networkManager else { return }
        self.employeesOperation = networkManager.createOperation(EmployeesOperation.self) as? EmployeesOperation
        
        guard let employeesOperation = self.employeesOperation, employeesOperation.isReadyToLoadData else { return }
        
        networkManager.requestData(operation: employeesOperation) { [weak self] employees, requestDidSucceed, error in
            guard let sself = self else { return }
            
            guard let allEmployees = employees as? [Employee] else {
                sself.errorOccured?()
                
                return
            }
            
            if !requestDidSucceed {
                sself.errorOccured?()
            }
            
            sself.employees = allEmployees
            
            sself.setUpPositions()
        }
    }
    
    private func setUpPositions() {
        guard let employees = self.employees else { return }

        var allPositions = [String]()
        
        for employee in employees as [Employee] {
            if !allPositions.contains(employee.position) {
               allPositions.append(employee.position)
            }
        }

        self.positions = allPositions.sorted(by: { $0 < $1 })
    }
    
    func employeesWithPosition(positionSection: Int) -> [Employee]? {
        guard let employees = self.employees, let allPositions = self.positions, let position = allPositions[positionSection] else { return nil }
        
        let employeesWithParticularPosition = employees.filter( { $0.position == position })
        
        return employeesWithParticularPosition.sorted(by: { $0.surname < $1.surname })
    }
    
}

extension EmployeeListViewModelImpl {
    
    func fetchDeviceContacts() {
        self.deviceContactsService = LocalContactsService()
        
        guard let deviceContactsService = self.deviceContactsService else { return }
        
        self.deviceContactsNames = deviceContactsService.localContactsNames()
        
        deviceContactsService.permissionRequestNeeded = {
            self.showContactsAlert?()
        }
    }
    
    func employeeIsInDeviceContacts(employee: Employee) -> Bool {
        guard let deviceContactsNames = self.deviceContactsNames else { return false }
        
        let fullName = String("\(employee.name) \(employee.surname)").lowercased()
        
        return deviceContactsNames.contains(fullName)
    }
    
    func deviceContact(fullName: String) -> CNContact? {
        guard let localContact = self.deviceContactsService?.contact(with: fullName) else {
            self.errorOccured?()
            return nil
        }
        
        return localContact
    }
    
}
