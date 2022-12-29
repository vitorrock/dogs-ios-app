//
//  Labels.swift
//  DogsApp
//
//  Created by Vítor Rocha on 29/12/2022.
//

import Foundation

protocol LabelsProtocol {
    func getLabel(for key: String) -> String
}

final class Labels: LabelsProtocol {
    func getLabel(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
