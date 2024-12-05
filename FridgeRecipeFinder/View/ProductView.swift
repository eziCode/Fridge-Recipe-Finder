//
//  ProductView.swift
//  FridgeRecipeFinder
//
//  Created by Ezra Akresh on 12/4/24.
//

import SwiftUI

struct ProductView: View {
    let product: Product
    
    var body: some View {
        VStack {
            Text("Product Name: \(product.product_name)")
            Text("Calcium: \(product.nutriments.calcium ?? 0) mg")
        }
    }
}
