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
    
    var localContacts: [CNContact]?
    var formattedContactsNames: [String]?
    
    func localContactsNames() -> [String]? {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            return nil
        }
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            guard let self = self else { return }
            
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
            
            self.localContacts = contacts
            
            let formatter = CNContactFormatter()
            formatter.style = .fullName
            
            let formattedContacts: [String]? = contacts.compactMap { formatter.string(from: $0)?.lowercased()
            }
            
            self.formattedContactsNames = formattedContacts
        }
        
        return formattedContactsNames
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
