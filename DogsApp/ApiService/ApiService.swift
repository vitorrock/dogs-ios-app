//
//  ApiService.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import Foundation

protocol ApiServiceProtocol {
    func getRequest<T: Decodable>(url: URL, type: T.Type, completion:  @escaping (Result<T,Error>) -> Void)
}

final class ApiService: ApiServiceProtocol {
    func getRequest<T: Decodable>(url: URL, type: T.Type, completion:  @escaping (Result<T,Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                debugPrint(error!)
                completion(.failure(error!))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
                debugPrint(error)
            }
        }
        
        task.resume()
    }
}
