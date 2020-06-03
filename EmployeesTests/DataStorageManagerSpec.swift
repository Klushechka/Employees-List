//
//  DataStorageManagerSpec.swift
//  EmployeesTests
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import XCTest
@testable import Employees

class DataStorageManagerSpec: XCTestCase {
    
    var dataStorageManager: DataStorageManager!

    override func setUp() {
        super.setUp()
        
        self.dataStorageManager = DataStorageManager()
    }

    override func tearDown() {
        super.tearDown()
        
        do {
            let url = self.dataStorageManager.fileURL(name: .test)
            if  FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: self.dataStorageManager.fileURL(name: .test))
                }
        }
        catch {
            print(error)
        }
    }

    func testCreatingFileForSavingData() {
        let john = Employee(
            name: "John",
            surname: "Doe",
            position: "iOS",
            contactDetails: ContactDetails(
                phone: "123 55 87",
                email: "john@example.com"
            ),
            projects: ["Mooncascade"]
        )
        
        let tom = Employee(
            name: "Tom",
            surname: "Green",
            position: "Android",
            contactDetails: ContactDetails(
                phone: "227 00 55",
                email: "tom@example.com"
            ),
            projects: ["Test Project"]
        )
        
        let employeesToSave = [john, tom]
        
        self.dataStorageManager.saveData(employeesToSave, fileName: .test)
        
        let fileURL = self.dataStorageManager.fileURL(name: .test)
        
        XCTAssert(FileManager.default.fileExists(atPath: fileURL.path))
    }
    
    func testFetchingSavedFullData() {
        let john = Employee(
            name: "John",
            surname: "Doe",
            position: "iOS",
            contactDetails: ContactDetails(
                phone: "123 55 87",
                email: "john@example.com"
            ),
            projects: ["Mooncascade"]
        )
        
        let tom = Employee(
            name: "Tom",
            surname: "Green",
            position: "Android",
            contactDetails: ContactDetails(
                phone: "227 00 55",
                email: "tom@example.com"
            ),
            projects: ["Test Project"]
        )
        
        let employeesToSave = [john, tom]
        
        self.dataStorageManager.saveData(employeesToSave, fileName: .test)
        
        let fetchedData = self.dataStorageManager.retrieveData(fileName: .test, dataType: [Employee].self)
        
        XCTAssertEqual(fetchedData, employeesToSave)
    }
    
    func testFetchingDataWithMissedData() {
        let john = Employee(
            name: "John",
            surname: "Doe",
            position: "iOS",
            contactDetails: ContactDetails(
                phone: nil,
                email: "john@example.com"
            ),
            projects: ["Mooncascade"]
        )
        
        let tom = Employee(
            name: "Tom",
            surname: "Green",
            position: "Android",
            contactDetails: ContactDetails(
                phone: "227 00 55",
                email: "tom@example.com"
            ),
            projects: nil
        )
        
        let employeesToSave = [john, tom]
        
        self.dataStorageManager.saveData(employeesToSave, fileName: .test)
        
        let fetchedData = self.dataStorageManager.retrieveData(fileName: .test, dataType: [Employee].self)
        
        XCTAssertEqual(fetchedData, employeesToSave)
    }
    
    func testUpdatingFileWithValidData() {
        let john = Employee(
            name: "John",
            surname: "Doe",
            position: "iOS",
            contactDetails: ContactDetails(
                phone: "123 55 87",
                email: "john@example.com"
            ),
            projects: ["Mooncascade"]
        )
        
        let tom = Employee(
            name: "Tom",
            surname: "Green",
            position: "Android",
            contactDetails: ContactDetails(
                phone: "227 00 55",
                email: "tom@example.com"
            ),
            projects: ["Test Project"]
        )
        
        let employeesToSave = [john, tom]
        
        self.dataStorageManager.saveData(employeesToSave, fileName: .test)
        
        let newDataToSave = [
            Employee(
                name: "Martin",
                surname: "Johanson",
                position: "PM",
                contactDetails: ContactDetails(
                    phone: "223 54 87",
                    email: "martin@example.com"
                ), projects: ["Startup"]
            )
        ]
        
        self.dataStorageManager.saveData(newDataToSave, fileName: .test)
        
        let fetchedData = self.dataStorageManager.retrieveData(fileName: .test, dataType: [Employee].self)
        
        XCTAssertEqual(fetchedData, newDataToSave)
    }
    
    func testNotUpdatingSavedDataWithNilData() {
        let john = Employee(
            name: "John",
            surname: "Doe",
            position: "iOS",
            contactDetails: ContactDetails(
                phone: "123 55 87",
                email: "john@example.com"
            ),
            projects: ["Mooncascade"]
        )
        
        let tom = Employee(
            name: "Tom",
            surname: "Green",
            position: "Android",
            contactDetails: ContactDetails(
                phone: "227 00 55",
                email: "tom@example.com"
            ),
            projects: ["Test Project"]
        )
        
        let employeesToSave = [john, tom]
        let nilDataToSave: [Employee]? = nil
        
        self.dataStorageManager.saveData(employeesToSave, fileName: .test)
        self.dataStorageManager.saveData(nilDataToSave, fileName: .test)
        
        let fetchedData = self.dataStorageManager.retrieveData(fileName: .test, dataType: [Employee].self)
        
        XCTAssertEqual(fetchedData, employeesToSave)
    }
    
    func testUpdateSavedDataWithEmptyData() {
        let john = Employee(
            name: "John",
            surname: "Doe",
            position: "iOS",
            contactDetails: ContactDetails(
                phone: "123 55 87",
                email: "john@example.com"
            ),
            projects: ["Mooncascade"]
        )
        
        let tom = Employee(
            name: "Tom",
            surname: "Green",
            position: "Android",
            contactDetails: ContactDetails(
                phone: "227 00 55",
                email: "tom@example.com"
            ),
            projects: ["Test Project"]
        )
        
        let employeesToSave = [john, tom]
        let emptyEmployeesList: [Employee] = []
        
        self.dataStorageManager.saveData(employeesToSave, fileName: .test)
        self.dataStorageManager.saveData(emptyEmployeesList, fileName: .test)
        
        let fetchedData = self.dataStorageManager.retrieveData(fileName: .test, dataType: [Employee].self)
        
        XCTAssertEqual(fetchedData, emptyEmployeesList)
    }
    
    func testFetchingDataFromNotExistingFile() {
        let fetchedResult =  self.dataStorageManager.retrieveData(fileName: .test, dataType: [Employee].self)
        
        XCTAssertEqual(fetchedResult, nil)
    }

}
