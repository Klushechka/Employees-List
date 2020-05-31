//
//  EndpointType.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: String { get }
}
