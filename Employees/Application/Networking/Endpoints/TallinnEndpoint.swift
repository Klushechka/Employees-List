//
//  TallinnEndpoint.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

enum TallinnEndpoint: String {
    case employeeList = "employee_list"
}

extension TallinnEndpoint: Endpoint {
    
    var baseURL: URL {
        return URL(string: "https://tallinn-jobapp.aw.ee/")!
    }
    
    var path: String {
        return self.rawValue
    }
    
    var httpMethod: String {
        return "GET"
    }
    
}
