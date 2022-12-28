//
//  ApiService.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import Foundation

protocol ApiServiceProtocol {
    func fetchBreeds(with limit: Int, page: Int, completion:  @escaping (Result<[Breed],Error>) -> Void)
    func fetchAllBreeds(completion:  @escaping (Result<[Breed],Error>) -> Void)
}

final class ApiService: ApiServiceProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchBreeds(with limit: Int, page: Int, completion:  @escaping (Result<[Breed],Error>) -> Void) {
        let breedsEndpoint = String(format: Endpoints.breedsWithPagination, limit, page)
        
        guard let url = URL(string: Endpoints.base + breedsEndpoint) else {
            let error = NSError(domain: "", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        getRequest(url: url, type: [Breed].self, completion: completion)
    }
    
    func fetchAllBreeds(completion:  @escaping (Result<[Breed],Error>) -> Void) {
        guard let url = URL(string: Endpoints.base + Endpoints.breeds) else {
            let error = NSError(domain: "", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        getRequest(url: url, type: [Breed].self, completion: completion)
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
