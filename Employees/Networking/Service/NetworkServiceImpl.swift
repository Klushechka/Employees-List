//
//  NetworkService.swift
//  Employees
//
//  Created by Olga Kliushkina on 27.05.2020.
//  Copyright © 2020 Olga Kliushkina. All rights reserved.
//

import Foundation

final class NetworkServiceImpl: NetworkService {
    
    private lazy var session: URLSession = URLSession.shared
    
    func request(_ endpoint: Endpoint, completion: @escaping SingleRequestCompletion) {
        let task = session.dataTask(with: request(endpoint: endpoint), completionHandler: { data, response, error in
            completion(data, response, error)
        })
        
        task.resume()
    }
    
    func multipleRequests(_ firstEndpoint: Endpoint, _ secondEndpoint: Endpoint, completion: @escaping MultipleRequestsCompletion) {
        
        let group = DispatchGroup()
        
        let outertask = self.session.dataTask(with: request(endpoint: firstEndpoint)) { [weak self] firstData, firstResponse, firstError in
            group.enter()
            
            guard let secondRequest = self?.request(endpoint: secondEndpoint) else {
                completion([(firstData, firstResponse, firstError), (nil, nil, nil)])
                
                return
            }
            
            let innerTask = self?.session.dataTask(with: secondRequest) { secondData, secondResponse, secondError  in
                completion([(firstData, firstResponse, firstError),
                    (secondData, secondResponse, secondError)])
                do {
                    group.leave()
                }
            }
            
            innerTask?.resume()
        }
        
        outertask.resume()
    }
    
    private func request(endpoint: Endpoint) -> URLRequest {
        var request = URLRequest(url: endpoint.baseURL.appendingPathComponent(endpoint.path))
        request.httpMethod = endpoint.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
}
