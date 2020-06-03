//
//  NetworkManager.swift
//  Employees
//
//  Created by Olga Kliushkina on 29.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func createOperation(_ operationClass: DataOperation.Type, dataStorageManager: DataStorageManager) -> DataOperation
    func requestData(operation: DataOperation, completion: @escaping (([Any]?), Bool, Error?) -> ())
}
