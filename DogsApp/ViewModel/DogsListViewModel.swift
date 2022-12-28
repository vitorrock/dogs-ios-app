//
//  DogsListViewModel.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import Foundation

protocol DogsListViewModelProtocol {
    
    var outputEvents: DogsListViewModel.OutputEvents { get set }
    
    func fetchDogs()
    func makeCellViewModel(for indexPath: IndexPath) -> DogsListCellViewModel
}

final class DogsListViewModel: DogsListViewModelProtocol {
    struct OutputEvents {
        var displayDogs: (([Breed]) -> Void)?
        var displayLoading: ((Bool) -> Void)?
    }
    
    var outputEvents: OutputEvents = .init()
    
    private var currentPage: Int = -1
    private var currentItems: [Breed] = []
    
    private static let limitOfItems: Int = 10
    
    private let apiService: ApiService
    
    init(apiService: ApiService = ApiService()) {
        self.apiService = apiService
    }
    
    func setup() {
        fetchDogs()
    }
    
    func makeCellViewModel(for indexPath: IndexPath) -> DogsListCellViewModel {
        let breed = currentItems[indexPath.row]
        return .init(
            image: breed.image,
            title: breed.name
        )
    }
    
    func fetchDogs() {
        outputEvents.displayLoading?(true)
        currentPage += 1
        apiService.fetchBreeds(
            with: Self.limitOfItems,
            page: currentPage,
            type: [Breed].self
        ) { [weak self] result in
            guard let self else { return }
            self.outputEvents.displayLoading?(false)
            switch result {
            case .failure(_):
                debugPrint("Error")
            case .success(let breeds):
                self.currentItems += breeds
                self.outputEvents.displayDogs?(self.currentItems)
            }
        }
    }
}
