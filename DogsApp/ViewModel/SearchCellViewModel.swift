//
//  SearchCellViewModel.swift
//  DogsApp
//
//  Created by Vítor Rocha on 28/12/2022.
//

import Foundation

protocol SearchCellViewModelProtocol {
    
    var name: String { get }
    var group: String? { get }
    var origin: String? { get }
}

final class SearchCellViewModel: SearchCellViewModelProtocol {
    
    var name: String
    var group: String?
    var origin: String?
    
    init(name: String, group: String?, origin: String?) {
        self.name = name
        self.group = group
        self.origin = origin
    }
}

