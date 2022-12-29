//
//  MockApiService.swift
//  DogsAppTests
//
//  Created by Vítor Rocha on 29/12/2022.
//

@testable import DogsApp
import Foundation

final class MockApiService: ApiServiceProtocol {
    var didCallFetchBreedsWithParameters: Bool = false
    var didCallFetchAllBreeds: Bool = false
    var mockResult: Result<[DogsApp.Breed], Error> = .failure(NSError(domain: "", code: -1, userInfo: nil))
    
    func fetchBreeds(with limit: Int, page: Int, completion: @escaping (Result<[DogsApp.Breed], Error>) -> Void) {
        didCallFetchBreedsWithParameters = true
        completion(mockResult)
    }
    
    func fetchAllBreeds(completion: @escaping (Result<[DogsApp.Breed], Error>) -> Void) {
        didCallFetchAllBreeds = true
        completion(mockResult)
    }
}
