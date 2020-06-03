//
//  LocalContactsService.swift
//  Employees
//
//  Created by Olga Kliushkina on 31.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

final class LocalContactsService {
    
    func localContactsNames(completion: @escaping (([String]?) -> Void)) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            return
        }
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else { return }
            
            var contacts = [CNContact]()
            let request = CNContactFetchRequest(keysToFetch: [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)])
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
            } catch {
                print(error)
            }
            
            let formatter = CNContactFormatter()
            formatter.style = .fullName
            
            let formattedContacts: [String]? = contacts.compactMap { formatter.string(from: $0)?.lowercased()
            }
            
            completion(formattedContacts)
        }
    }
    
    func contact(with fullName: String) -> CNContact? {
        var results: [CNContact] = []
        do {
            let contactStore = CNContactStore()
            
            let request:CNContactFetchRequest
            request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as NSString, CNContactFamilyNameKey as NSString, CNContactViewController.descriptorForRequiredKeys()])
            request.predicate = CNContact.predicateForContacts(matchingName: fullName)
            try contactStore.enumerateContacts(with: request) {
                (contact, cursor) -> Void in
                results.append(contact)
            }
        }
        catch{
            print(error)
        }
        
        return results.first
    }
    
}
