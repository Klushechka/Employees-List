//
//  TartuEndpoint.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

enum TartuEndpoint: String {
    case employeeList = "employee_list"
}

extension TartuEndpoint: Endpoint {
    
    var baseURL: URL {
        return URL(string: "https://tartu-jobapp.aw.ee/")!
    }
    
    var path: String {
        return self.rawValue
    }
    
    var httpMethod: String {
        return "GET"
    }
    
}
