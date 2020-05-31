//
//  DataStorageManager.swift
//  Employees
//
//  Created by Olga Kliushkina on 30.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

enum FileName: String {
    case employees
}

final class DataStorageManager {
    
    func saveData<T: Encodable>(_ data: T, fileName: FileName) {
        let url = fileURL(name: fileName)
        
        do {
            let jsonEncodedData = try JSONEncoder().encode(data as? [Employee])
            
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            
            FileManager.default.createFile(atPath: url.path, contents: jsonEncodedData, attributes: nil)
        }
        catch {
            print("Couldn't save the data. \(error)")
        }
    }
    
    func retrieveData<T: Decodable>(fileName: FileName, dataType: T.Type) -> T? {
        let url = fileURL(name: fileName)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            print("File at path \(url.path) does not exist.")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
                   let decoder = JSONDecoder()
                   do {
                    let model = try decoder.decode(T.self, from: data)
                       return model
                   } catch {
                       print("Couldn't retrieve the data \(error)")
                   }
        }
        
        return nil
    }
    
    func fileURL(name: FileName) -> URL {
        let documentURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        return documentURL.appendingPathComponent(name.rawValue)
    }
    
}
