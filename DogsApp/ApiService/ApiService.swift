//
//  ApiService.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import Foundation

protocol ApiServiceProtocol {
    func fetchBreeds<T: Decodable>(with limit: Int, page: Int, type: T.Type, completion:  @escaping (Result<T,Error>) -> Void)
}

final class ApiService: ApiServiceProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchBreeds<T: Decodable>(with limit: Int, page: Int, type: T.Type, completion:  @escaping (Result<T,Error>) -> Void) {
        let breedsEndpoint = String(format: Endpoints.breeds, limit, page)
        
        guard let url = URL(string: Endpoints.base + breedsEndpoint) else {
            let error = NSError(domain: "", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        getRequest(url: url, type: type, completion: completion)
    }
    
    private func getRequest<T: Decodable>(url: URL, type: T.Type, completion:  @escaping (Result<T,Error>) -> Void) {
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            
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
