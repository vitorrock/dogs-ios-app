//
//  ImageDownloader.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import Foundation
import Kingfisher
import UIKit

protocol ImageDownloaderProtocol {
    func download(
        url: URL,
        cacheKey: String?,
        completion: @escaping ((Result<UIImage, Error>) -> Void)
    )
}

final class ImageDownloader: ImageDownloaderProtocol {
    
    func download(
        url: URL,
        cacheKey: String?,
        completion: @escaping ((Result<UIImage, Error>) -> Void)
    ) {
        let options: [KingfisherOptionsInfoItem] = [.cacheOriginalImage]
        
        let imageResource: Kingfisher.ImageResource = .init(
            downloadURL: url,
            cacheKey: cacheKey
        )
        
        Kingfisher
            .KingfisherManager
            .shared
            .retrieveImage(
                with: imageResource,
                options: options) { result in
                    switch result {
                    case .success(let retrieveImageResult):
                        completion(.success(retrieveImageResult.image))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
    }
}
