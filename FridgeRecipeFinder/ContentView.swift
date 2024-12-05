//
//  ContentView.swift
//  FridgeRecipeFinder
//
//  Created by Ezra Akresh on 12/2/24.
//

import SwiftUI

struct ContentView: View {
    /// ScannerView
    @State private var showScanner: Bool = false
    @State private var scannedCode: String = ""
    
    /// ProductView
    @State private var product: Product? = nil
    @State private var showProductView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        showScanner = true
                    } label: {
                        Image(systemName: "camera.viewfinder")
                            .font(.title3)
                            .foregroundColor(Color("BlueishPurple"))
                    }
                    .padding()
                    .sheet(isPresented: $showScanner) {
                        ScannerView(showScanner: $showScanner, scannedCode: $scannedCode)
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: scannedCode) {
            /// Retrieve Information about Product from Open Food Facts API
            fetchProductData()
        }
        .onChange(of: product) { _, newValue in
            showProductView = true
        }
        .sheet(isPresented: $showProductView) {
            ProductView(product: product!)
        }
    }
    
    func fetchProductData() {
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v3/product/\(scannedCode).json") else {
            print("Invalid Barcode: Please Scan Again")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching product data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data recieved")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(APIResponse.self, from: data)
                product = decodedData.product
                showProductView = true
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
        }
        task.resume()
    }
    
}

#Preview {
    ContentView()
}
