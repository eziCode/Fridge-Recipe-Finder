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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.product_name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("Brand: \(product.brands)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let keywords = product.keywords {
                        Text("Keywords: \(keywords.joined(separator: ", "))")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                .shadow(radius: 2)
                
                // Nutritional Information Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nutritional Information")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 8)
                    
                    NutrientRow(name: "Calcium", value: product.nutriments.calcium, unit: "mg")
                    NutrientRow(name: "Carbohydrates", value: product.nutriments.carbohydrates, unit: "g")
                    NutrientRow(name: "Energy", value: product.nutriments.energy, unit: "kcal")
                    NutrientRow(name: "Fat", value: product.nutriments.fat, unit: "g")
                    NutrientRow(name: "Fiber", value: product.nutriments.fiber, unit: "g")
                    NutrientRow(name: "Proteins", value: product.nutriments.proteins, unit: "g")
                    NutrientRow(name: "Salt", value: product.nutriments.salt, unit: "g")
                    NutrientRow(name: "Saturated Fat", value: product.nutriments.saturatedFat, unit: "g")
                    NutrientRow(name: "Sugars", value: product.nutriments.sugars, unit: "g")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                .shadow(radius: 2)
                
                // Nutri-Score Section
                VStack(alignment: .center) {
                    Text("Nutri-Score")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("\(product.nutriscoreScore != nil ? "\(product.nutriscoreScore!)" : "Not Available")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                .shadow(radius: 2)
            }
            .padding()
            
            Button(action: {
                /// Add Ingredient to database
                print("Add Ingredient button tapped for \(product.product_name)")
            }) {
                Text("Add Ingredient")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
        }
        .background(Color(.systemBackground))
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NutrientRow: View {
    let name: String
    let value: Double?
    let unit: String
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.medium)
            Spacer()
            Text("\(value ?? 0, specifier: "%.2f") \(unit)")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let sampleNutriments = Nutriments(
            calcium: 120.0,
            carbohydrates: 15.0,
            energy: 200.0,
            fat: 5.0,
            fiber: 3.0,
            proteins: 10.0,
            salt: 1.2,
            saturatedFat: 1.5,
            sugars: 8.0
        )
    let sampleProduct = Product(
        product_name: "Sample Milk",
        product_name_en: "Sample Milk (English)",
        brands: "Sample Brand",
        nutriments: sampleNutriments,
        nutriscoreScore: 70,
        keywords: ["milk", "dairy", "calcium"]
    )
    ProductView(product: sampleProduct)
}
