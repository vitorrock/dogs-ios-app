//
//  DogDetailsViewModel.swift
//  DogsApp
//
//  Created by Vítor Rocha on 29/12/2022.
//

import Foundation
import UIKit

protocol DogDetailsViewModelProtocol {
    
    var outputEvents: DogDetailsViewModel.OutputEvents { get set }
    var name: String { get }
    var group: String? { get }
    var origin: String? { get }
    var temperament: String? { get }
    
    func fetchImage()
}

final class DogDetailsViewModel: DogDetailsViewModelProtocol {
    
    struct OutputEvents {
        var displayImage: ((UIImage) -> Void)?
    }
    
    var outputEvents: OutputEvents = .init()
    var name: String
    var group: String?
    var origin: String?
    var temperament: String?
    
    private var image: Image
    private let imageDownloader: ImageDownloaderProtocol
    
    init(
        imageDownloader: ImageDownloaderProtocol = ImageDownloader(),
        name: String,
        group: String? = nil,
        origin: String? = nil,
        temperament: String? = nil,
        image: Image
    ) {
        self.imageDownloader = imageDownloader
        self.name = name
        self.group = group
        self.origin = origin
        self.temperament = temperament
        self.image = image
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

