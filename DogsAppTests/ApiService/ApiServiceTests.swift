//
//  ApiServiceTests.swift
//  DogsAppTests
//
//  Created by Vítor Rocha on 29/12/2022.
//

@testable import DogsApp
import UIKit
import XCTest

class ApiServiceTests: XCTestCase {

    let imageUrl = URL(string: "https://www.shutterstock.com/image-photo/red-apple-isolated-on-white-600w-1727544364.jpg")!
    private var apiService: ApiService!
    
    override func setUp() {
        super.setUp()
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: urlSessionConfiguration)
        
        apiService = ApiService(urlSession: urlSession)
    }

    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func test_FetchAllBreeds_WithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch all breeds completion")
        let data = succesfullMockJsonResponse.data(using: .utf8)
        mockRequestHandler(with: data)
        
        apiService.fetchAllBreeds { result in
            guard let breeds = try? result.get(),
                  let breed = breeds.first else {
                XCTFail("Expected breeds")
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(breed.name, "Affenpinscher")
            XCTAssertEqual(breed.id, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FetchBreeds_WithParameters_WithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch all breeds completion")
        let data = succesfullMockJsonResponse.data(using: .utf8)
        mockRequestHandler(with: data)
        
        apiService.fetchBreeds(with: 10, page: 0) { result in
            guard let breeds = try? result.get(),
                  let breed = breeds.first else {
                XCTFail("Expected breeds")
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(breed.name, "Affenpinscher")
            XCTAssertEqual(breed.id, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FetchAllBreeds_WithFaillure() {
        let expectation = XCTestExpectation(description: "Fetch all breeds completion")
        mockRequestHandler(with: Data())
        
        apiService.fetchAllBreeds { result in
            XCTAssertNil(try? result.get())
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FetchBreeds_WithParameters_WithFaillure() {
        let expectation = XCTestExpectation(description: "Fetch all breeds completion")
        mockRequestHandler(with: Data())
        
        apiService.fetchBreeds(with: 10, page: 0) { result in
            XCTAssertNil(try? result.get())
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    private func mockRequestHandler(with data: Data?) {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NSError(domain: "", code: -1)
            }
            
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
    }
}
