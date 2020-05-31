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
    private lazy var responseHandler = NetworkResponseHandler()
    private lazy var dataStorageManager = DataStorageManager()
    
    func createOperation(_ operationClass: DataOperation.Type) -> DataOperation {
        return (operationClass.self).init(networkService: self.networkService, responseHandler: self.responseHandler, dataStorageManager: self.dataStorageManager)
        }
    
    func requestData(operation: DataOperation, completion: @escaping ((Array<Any>?), Bool, Error?) -> ()) {
        operation.requestData() { elements, requestSucceeded, error in
            completion(elements, requestSucceeded, error)
        }
    }
    
//    func requestData<T>(operation: DataOperation, completion: @escaping (T?, Bool, Error?) -> ()) where T : Collection {
//        operation.requestData() { elements, requestSucceeded, error in
//        completion(elements, requestSucceeded, error)
//            saveData(data: elements)
//        }
//    }
    
    func saveData<T>(data: T) where T : Encodable {
        self.dataStorageManager.saveData(data, fileName: .employees)
    }
    
    func retrieveData<T>(fileName: FileName, dataType: T.Type) -> T? where T : Decodable {
        
        self.dataStorageManager.retrieveData(fileName: fileName, dataType: dataType)
    }
    
}
