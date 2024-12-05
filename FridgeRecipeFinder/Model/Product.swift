//
//  Product.swift
//  FridgeRecipeFinder
//
//  Created by Ezra Akresh on 12/4/24.
//

import SwiftUI

struct APIResponse: Codable {
    let product: Product
}

struct Product: Codable {
    let product_name: String
    let product_name_en: String?
    let brands: String
    let nutriments: Nutriments
    let nutriscoreScore: Int?
    let keywords: [String]?
    
    enum CodingKeys: String, CodingKey {
        case product_name
        case product_name_en
        case brands
        case nutriments
        case nutriscoreScore = "nutriscore_score"
        case keywords = "_keywords"
    }
}

struct Nutriments: Codable {
    let calcium: Double?
    let carbohydrates: Double?
    let energy: Double?
    let fat: Double?
    let fiber: Double?
    let proteins: Double?
    let salt: Double?
    let saturatedFat: Double?
    let sugars: Double?

    enum CodingKeys: String, CodingKey {
        case calcium
        case carbohydrates
        case energy
        case fat
        case fiber
        case proteins
        case salt
        case saturatedFat = "saturated-fat"
        case sugars
    }
}

