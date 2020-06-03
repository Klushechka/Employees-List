//
//  EmployeesOperation.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

class EmployeesOperation: DataOperation {
    
    private let networkService: NetworkService
    private let dataStorageManager: DataStorageManager
    private(set) var isReadyToLoadData: Bool = true
    
    required init(networkService: NetworkService, dataStorageManager: DataStorageManager) {
        self.networkService = networkService
        self.dataStorageManager = dataStorageManager
    }
        
    func requestData(completion: @escaping (([Any]?), Bool, Error?) -> ()) {
        let tallinnEndpoint: TallinnEndpoint = .employeeList
        let tartuEndpoint: TartuEndpoint = .employeeList
        
        self.isReadyToLoadData = false
        
        self.networkService.multipleRequests(tallinnEndpoint, tartuEndpoint) { [weak self] requestsResults in
            guard let sself = self else { return }
            
            var decodedEmployees = [Employee]()
            var requestSucceeded = false
            var receivedErrors = [Error?]()
            
            for result in requestsResults {
                if let response = result.response as? HTTPURLResponse, response.statusCode == 200, let data = result.data, let decodedData = sself.decode(data: data) {
                    decodedEmployees.append(contentsOf: decodedData)
                    requestSucceeded = true
                }
                else {
                    requestSucceeded = false
                }
                
                if let error = result.error {
                    receivedErrors.append(error)
                    
                    print(error)
                }
            }
            
            let errorToSend = receivedErrors.first(where: { $0 != nil }) ?? nil
            
            let uniqueEmployees = Array(Set(decodedEmployees))
            
            if requestSucceeded {
                sself.saveData(data: uniqueEmployees)
            }
            
            completion(uniqueEmployees, requestSucceeded, errorToSend)
        }
    }
    
    private func decode(data: Data?) -> [Employee]? {
        guard let data = data else { return nil }
        do {
            let rootData = try JSONDecoder().decode(Root.self, from: data)
            
            return rootData.employees
        }
        catch {
            print(error)
            
            return nil
        }
    }
    
}

extension EmployeesOperation {
    
    internal func saveData<T>(data: T) where T : Encodable {
        self.dataStorageManager.saveData(data, fileName: .employees)
    }
    
}
