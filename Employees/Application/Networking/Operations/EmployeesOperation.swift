//
//  EmployeesOperation.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

class EmployeesOperation: DataOperation {
    
    public typealias Completion = ((_ employees: [Employee]?) -> ())
    
    private let networkService: NetworkService
    private let responseHandler: NetworkResponseHandler
    private let dataStorageManager: DataStorageManager
    private(set) var isReadyToLoadData: Bool = true
    
    required init(networkService: NetworkService, responseHandler: NetworkResponseHandler, dataStorageManager: DataStorageManager) {
        self.networkService = networkService
        self.responseHandler = responseHandler
        self.dataStorageManager = dataStorageManager
    }
    
   // func requestData(completion: @escaping ((Array<Any>?), Bool, Error?) -> ()) {
        
    func requestData(completion: @escaping ((Array<Any>?), Bool, Error?) -> ()) {
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
                else if let response = result.response as? HTTPURLResponse, response.statusCode != 200 {
                    requestSucceeded = false
                }
                
                if let error = result.error {
                    receivedErrors.append(error)
                }
            }
            
            let errorToSend = receivedErrors.first(where: { $0 != nil }) ?? nil
            
            let uniqueEmployees = Array(Set(decodedEmployees))
            sself.saveData(data: uniqueEmployees)
            
            completion(uniqueEmployees, requestSucceeded, errorToSend)
        }
    }
    
    private func decode(data: Data?) -> [Employee]? {
        guard let data = data else {
            return nil
        }
        do {
            let rootData = try JSONDecoder().decode(Root.self, from: data)
            
            return rootData.employees
        }
        catch {
            print (NetworkResponse.unableToDecode.rawValue)
            
            return nil
        }
    }
    
}

extension EmployeesOperation {
    
    private func handle(response: HTTPURLResponse?) {
        guard let response = response else { return }
            
        let result = self.responseHandler.handleNetworkResponse(response)
        
        switch result {
        case .failure(let errorDescription): print(errorDescription)

        default: break
        }
    }
    
}

extension EmployeesOperation {
    
    func saveData<T>(data: T) where T : Encodable {
        self.dataStorageManager.saveData(data, fileName: .employees)
        
        //fetchData()
    }
    
    func fetchData() {
        print ("FETCHED EMPLOYEES: \(String(describing: self.dataStorageManager.retrieveData(fileName: .employees, dataType: [Employee].self)))")
    }
    
}
