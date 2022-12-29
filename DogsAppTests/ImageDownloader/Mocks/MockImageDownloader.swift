//
//  File.swift
//  DogsAppTests
//
//  Created by Vítor Rocha on 29/12/2022.
//

@testable import DogsApp
import Foundation
import UIKit

final class MockImageDownloader: ImageDownloaderProtocol {
    
    var didCallDownload: Bool = false
    var mockResult: Result<UIImage, Error> = .failure(NSError(domain: "", code: -1, userInfo: nil))
    
    func download(
        url: URL,
        cacheKey: String?,
        completion: @escaping ((Result<UIImage, Error>) -> Void)
    ) {
        didCallDownload = true
        completion(mockResult)
    }
}
