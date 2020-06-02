//
//  NetworkingManager.swift
//  Employees
//
//  Created by Olga Kliushkina on 29.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

final class NetworkingManager: NetworkManagerProtocol {
    
    private lazy var networkService = NetworkServiceImpl()
    private lazy var dataStorageManager = DataStorageManager()
    
    func createOperation(_ operationClass: DataOperation.Type) -> DataOperation {
        return (operationClass.self).init(networkService: self.networkService, dataStorageManager: self.dataStorageManager)
    }
    
    func requestData(operation: DataOperation, completion: @escaping (([Any]?), Bool, Error?) -> ()) {
        operation.requestData() { elements, requestSucceeded, error in
            completion(elements, requestSucceeded, error)
        }
    }
    
    func retrieveData<T>(fileName: FileName, dataType: T.Type) -> T? where T : Decodable {
        self.dataStorageManager.retrieveData(fileName: fileName, dataType: dataType)
    }
    
}
