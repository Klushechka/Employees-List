//
//  ContactDetails.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

struct ContactDetails: Codable {
    
    var phone: String?
    var email: String
    
    private enum CodingKeys: String, CodingKey {
        case phone
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.phone = try? container.decodeIfPresent(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.phone, forKey: .phone)
        try container.encode(self.email, forKey: .email)
    }
    
}

extension ContactDetails: Hashable, Equatable {
    
    static func == (lhs: ContactDetails, rhs: ContactDetails) -> Bool {
        guard lhs.email == rhs.email else { return false }
        guard lhs.phone == rhs.phone else { return false }
        
        return true
    }
    
}
