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
    
    private let apiService: ApiService
    
    init(apiService: ApiService = ApiService(),
         image: Image,
         title: String) {
        self.apiService = apiService
        self.image = image
        self.title = title
    }
    
    func fetchImage() {
        //TODO: fetch dog image
    }
}

