//
//  SearchViewModel.swift
//  DogsApp
//
//  Created by Vítor Rocha on 28/12/2022.
//

import Foundation

protocol SearchViewModelProtocol {
    
    var outputEvents: SearchViewModel.OutputEvents { get set }
    
    func setup()
    func numberOfItem() -> Int
    func searchBreed(with searchString: String)
    func makeCellViewModel(for indexPath: IndexPath) -> SearchCellViewModelProtocol
}

final class SearchViewModel: SearchViewModelProtocol {
    
    struct OutputEvents {
        var displayDogs: (([Breed]) -> Void)?
        var displayLoading: ((Bool) -> Void)?
    }
    
    var outputEvents: OutputEvents = .init()
    
    private var allItems: [Breed] = []
    private var filteredItems: [Breed] = []
    
    private let apiService: ApiServiceProtocol
    
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    func setup() {
        fetchDogs()
    }
    
    func numberOfItem() -> Int {
        return filteredItems.count
    }
    
    func searchBreed(with searchString: String) {
        filteredItems = allItems.filter {
            $0.name.hasPrefix(searchString)
        }
        
        outputEvents.displayDogs?(filteredItems)
    }
    
    func makeCellViewModel(for indexPath: IndexPath) -> SearchCellViewModelProtocol {
        let breed = filteredItems[indexPath.row]
        return SearchCellViewModel(
            name: breed.name,
            group: breed.breedGroup?.rawValue,
            origin: breed.origin
        )
    }
    
    func fetchDogs() {
        outputEvents.displayLoading?(true)
        apiService.fetchAllBreeds(
            completion: { [weak self] result in
                guard let self else { return }
                self.outputEvents.displayLoading?(false)
                switch result {
                case .failure(_):
                    debugPrint("Error")
                case .success(let breeds):
                    self.allItems = breeds
                    self.filteredItems = breeds
                    self.outputEvents.displayDogs?(self.filteredItems)
                }
            }
        )
    }
}
