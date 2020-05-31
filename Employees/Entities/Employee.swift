//
//  Employee.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

struct Root: Codable {
    
    var employees: [Employee]?
    
}

struct Employee: Codable {
    
    var name: String
    var surname: String
    var contactDetails: ContactDetails?
    var position: String
    var projects: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case name = "fname"
        case surname = "lname"
        case contactDetails = "contact_details"
        case position = "position"
        case projects = "projects"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.surname = try container.decode(String.self, forKey: .surname)
        self.contactDetails = try container.decodeIfPresent(ContactDetails.self, forKey: .contactDetails)
        self.position = try container.decode(String.self, forKey: .position)
        self.projects = try container.decodeIfPresent([String].self, forKey: .projects)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.surname, forKey: .surname)
        try container.encodeIfPresent(self.contactDetails, forKey: .contactDetails)
        try container.encode(self.position, forKey: .position)
        try container.encodeIfPresent(self.projects, forKey: .projects)
    }
    
}

extension Employee: Hashable, Equatable {
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        guard lhs.name == rhs.name else {
            return false
        }
        guard lhs.surname == rhs.surname else {
            return false
        }
        
        return true
    }
    
}
