//
//  DogsListCellViewModel.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import Foundation
import UIKit

protocol DogsListCellViewModelProtocol {
    
    var outputEvents: DogsListCellViewModel.OutputEvents { get set }
    var title: String { get }

    func fetchImage()
}

final class DogsListCellViewModel: DogsListCellViewModelProtocol {
    
    struct OutputEvents {
        var displayImage: ((UIImage) -> Void)?
    }
    
    var outputEvents: OutputEvents = .init()
    var title: String
    
    private var image: Image
    private var currentPage: Int = 0
    
    private static let limitOfItems: Int = 10
    
    private let imageDownloader: ImageDownloaderProtocol
    
    init(imageDownloader: ImageDownloaderProtocol = ImageDownloader(),
         image: Image,
         title: String) {
        self.imageDownloader = imageDownloader
        self.image = image
        self.title = title
    }
    
    func fetchImage() {
        guard let url = URL(string: image.url) else { return }
        imageDownloader.download(url: url, cacheKey: image.id) { [weak self] result in
            switch result {
            case .success(let image):
                self?.outputEvents.displayImage?(image)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

