//
//  ProductView.swift
//  FridgeRecipeFinder
//
//  Created by Ezra Akresh on 12/4/24.
//

import SwiftUI

struct ProductView: View {
    @Binding var showProductView: Bool
    @Binding var product: Product?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(product?.product_name ?? "Not Available")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("Brand: \(product?.brands ?? "Not Available")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let keywords = product?.keywords {
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
                    
                    NutrientRow(name: "Calcium", value: product?.nutriments.calcium, unit: "mg")
                    NutrientRow(name: "Carbohydrates", value: product?.nutriments.carbohydrates, unit: "g")
                    NutrientRow(name: "Energy", value: product?.nutriments.energy, unit: "kcal")
                    NutrientRow(name: "Fat", value: product?.nutriments.fat, unit: "g")
                    NutrientRow(name: "Fiber", value: product?.nutriments.fiber, unit: "g")
                    NutrientRow(name: "Proteins", value: product?.nutriments.proteins, unit: "g")
                    NutrientRow(name: "Salt", value: product?.nutriments.salt, unit: "g")
                    NutrientRow(name: "Saturated Fat", value: product?.nutriments.saturatedFat, unit: "g")
                    NutrientRow(name: "Sugars", value: product?.nutriments.sugars, unit: "g")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                .shadow(radius: 2)
                
                // Nutri-Score Section
                VStack(alignment: .center) {
                    Text("Nutri-Score")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("\(product?.nutriscoreScore != nil ? "\(String(describing: product?.nutriscoreScore!))" : "Not Available")")
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
                showProductView = false
                addProductToDatabase()
                product = nil
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
    
    // TODO: Add button where user can increment the number of ingredients they have
    // TODO: Finish this function
    func addProductToDatabase() {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        guard let url = URL(string: "http://192.168.40.68:3000/addProductToFridge") else {
            print("Server not online")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userId": uuid,
            "product_name": product?.product_name as Any,
            "product_name_en": product?.product_name_en ?? product?.product_name as Any,
            "brands": product?.brands as Any,
            "nutriments": [
                "calcium": product?.nutriments.calcium,
                "carbohydrates": product?.nutriments.carbohydrates,
                "energy": product?.nutriments.energy,
                "fat": product?.nutriments.fat,
                "fiber": product?.nutriments.fiber,
                "proteins": product?.nutriments.proteins,
                "salt": product?.nutriments.salt,
                "saturatedFat": product?.nutriments.saturatedFat,
                "sugars": product?.nutriments.sugars
            ],
            "nutriscoreScore": product?.nutriscoreScore ?? -1.0,
            "keywords": product?.keywords ?? ["n/a"]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize body: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to send request: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Unexpected response from server")
                return
            }
            print("Product added successfully")
        }
        task.resume()
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
