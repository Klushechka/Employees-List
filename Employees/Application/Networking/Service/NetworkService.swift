//
//  NetworkService.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

public typealias SingleRequestCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()
public typealias RequestResult = (data: Data?, response: URLResponse?, error: Error?)
public typealias MultipleRequestsCompletion = ([RequestResult]) -> ()

protocol NetworkService {
    func request(_ route: Endpoint, completion: @escaping SingleRequestCompletion)
    func multipleRequests(_ firstEndpoint: Endpoint, _ secondEndpoint: Endpoint, completion: @escaping MultipleRequestsCompletion)
}
