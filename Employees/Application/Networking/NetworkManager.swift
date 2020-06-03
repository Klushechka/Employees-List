//
//  NetworkManager.swift
//  Employees
//
//  Created by Olga Kliushkina on 29.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

final class NetworkManager: NetworkManagerProtocol {
    
    private lazy var networkService = NetworkServiceImpl()
    
    func createOperation(_ operationClass: DataOperation.Type, dataStorageManager: DataStorageManager) -> DataOperation {
        return (operationClass.self).init(networkService: self.networkService, dataStorageManager: dataStorageManager)
    }
    
    func requestData(operation: DataOperation, completion: @escaping (([Any]?), Bool, Error?) -> ()) {
        operation.requestData() { elements, requestSucceeded, error in
            completion(elements, requestSucceeded, error)
        }
    }
    
}
