//
//  ImageDownloaderTests.swift
//  DogsAppTests
//
//  Created by Vítor Rocha on 29/12/2022.
//

@testable import DogsApp
import UIKit
import XCTest

class ImageDownloaderTests: XCTestCase {
    
    let imageUrl = URL(string: "https://www.shutterstock.com/image-photo/red-apple-isolated-on-white-600w-1727544364.jpg")!
    private var imageDownloader: ImageDownloader!
    
    override func setUp() {
        super.setUp()
        imageDownloader = ImageDownloader()
    }

    override func tearDown() {
        imageDownloader = nil
        super.tearDown()
    }
    
    func test_Download_Should_Return_Image() {
        let expectation = XCTestExpectation(description: "Download image completion")
        imageDownloader.download(url: imageUrl, cacheKey: nil) { result in
            XCTAssertNotNil(try? result.get())
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Download_Should_Return_Nil() {
        let expectation = XCTestExpectation(description: "Download image completion")
        let url = URL(string: "random_url")!
        imageDownloader.download(url: url, cacheKey: nil) { result in
            XCTAssertNil(try? result.get())
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
