//
//  File.swift
//  DogsApp
//
//  Created by Vítor Rocha on 27/12/2022.
//

import Foundation

// MARK: - Breed

struct Breed: Codable, Hashable {
    let weight: MeasureUnit
    let height: MeasureUnit
    let id: Int
    let name: String
    let bredFor: String?
    let breedGroup: BreedGroup?
    let lifeSpan: String
    let temperament: String?
    let origin: String?
    let referenceImageID: String
    let image: Image
    let countryCode: String?
    let welcomeDescription: String?
    let history: String?
    
    enum CodingKeys: String, CodingKey {
        case weight
        case height
        case id
        case name
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case lifeSpan = "life_span"
        case temperament
        case origin
        case referenceImageID = "reference_image_id"
        case image
        case countryCode = "country_code"
        case welcomeDescription = "description"
        case history
    }
}

// MARK: - MeasureUnit

struct MeasureUnit: Codable, Hashable {
    let imperial: String
    let metric: String
}

// MARK: - BreedGroup

enum BreedGroup: String, Codable, Hashable {
    case empty = ""
    case herding = "Herding"
    case hound = "Hound"
    case mixed = "Mixed"
    case nonSporting = "Non-Sporting"
    case sporting = "Sporting"
    case terrier = "Terrier"
    case toy = "Toy"
    case working = "Working"
}

// MARK: - Image

struct Image: Codable, Hashable {
    let id: String
    let width:Int
    let height: Int
    let url: String
}
