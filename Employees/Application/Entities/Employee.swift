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
    var contactDetails: ContactDetails
    var position: String
    var projects: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case name = "fname"
        case surname = "lname"
        case contactDetails = "contact_details"
        case position = "position"
        case projects = "projects"
    }
    
    init(name: String, surname: String, position: String, contactDetails: ContactDetails, projects: [String]?) {
        self.name = name
        self.surname = surname
        self.position = position
        self.contactDetails = contactDetails
        self.projects = projects
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let surname = try container.decode(String.self, forKey: .surname)
        let contactDetails = try container.decode(ContactDetails.self, forKey: .contactDetails)
        let position = try container.decode(String.self, forKey: .position)
        let projects = try container.decodeIfPresent([String].self, forKey: .projects)
        
        self.init(name: name, surname: surname, position: position, contactDetails: contactDetails, projects: projects)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.surname, forKey: .surname)
        try container.encode(self.contactDetails, forKey: .contactDetails)
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
