//
//  DogsListViewModel.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import Foundation
import UIKit

protocol DogsListViewModelProtocol {
    
    var outputEvents: DogsListViewModel.OutputEvents { get set }
    
    func fetchDogs()
    func makeMenuActionItems() -> [UIAction]
    func makeCellViewModel(for indexPath: IndexPath) -> DogsListCellViewModelProtocol
    func makeDetailsViewModel(for indexPath: IndexPath) -> DogDetailsViewModelProtocol
}

final class DogsListViewModel: DogsListViewModelProtocol {
    private enum Constants {
        static let sortNameAlphabetical = "Name A-Z"
        static let sortNameReverseAlphabetical = "Name Z-A"
    }
    
    struct OutputEvents {
        var displayDogs: (([Breed]) -> Void)?
        var displayLoading: ((Bool) -> Void)?
    }
    
    var outputEvents: OutputEvents = .init()
    
    private var currentPage: Int = -1
    private var currentItems: [Breed] = []
    
    private static let limitOfItems: Int = 10
    
    private let apiService: ApiServiceProtocol
    
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    func makeMenuActionItems() -> [UIAction] {
        return [
            .init(
                title: Constants.sortNameAlphabetical,
                image: UIImage(systemName: "arrow.down"),
                handler: { [weak self] action in
                    self?.sortItems(.alphabetical)
                }
            ),
            .init(
                title: Constants.sortNameReverseAlphabetical,
                image: UIImage(systemName: "arrow.up"),
                handler: { [weak self] action in
                    self?.sortItems(.reverseAlphabetical)
                }
            ),
        ]
    }
    
    func makeCellViewModel(for indexPath: IndexPath) -> DogsListCellViewModelProtocol {
        let breed = currentItems[indexPath.row]
        return DogsListCellViewModel(
            image: breed.image,
            title: breed.name
        )
    }
    
    func makeDetailsViewModel(for indexPath: IndexPath) -> DogDetailsViewModelProtocol {
        let breed = currentItems[indexPath.row]
        return DogDetailsViewModel(
            name: breed.name,
            group: breed.breedGroup?.rawValue,
            origin: breed.origin,
            temperament: breed.temperament,
            image: breed.image
        )
    }
    
    func fetchDogs() {
        outputEvents.displayLoading?(true)
        currentPage += 1
        apiService.fetchBreeds(
            with: Self.limitOfItems,
            page: currentPage
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
    
    private func sortItems(_ sortAction: SortAction) {
        switch sortAction {
        case .alphabetical:
            currentItems = currentItems.sorted{ $0.name < $1.name }
        case .reverseAlphabetical:
            currentItems = currentItems.sorted{ $0.name > $1.name }
        default:
            return
        }
        
        self.outputEvents.displayDogs?(self.currentItems)
    }
}
