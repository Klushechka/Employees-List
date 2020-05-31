//
//  DataOperation.swift
//  Employees
//
//  Created by Olga Kliushkina on 28.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

protocol DataOperation: class {
    
    init(networkService: NetworkService, responseHandler: NetworkResponseHandler, dataStorageManager: DataStorageManager)
    
    var isReadyToLoadData: Bool { get }
    
    func requestData(completion: @escaping (_ data: [Any]?, _ requestSucceeded: Bool, _ error: Error?) -> ())
    
    func saveData<T: Encodable>(data: T)
    func fetchData()
    
}
