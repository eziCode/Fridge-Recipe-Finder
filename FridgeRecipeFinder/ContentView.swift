//
//  ContentView.swift
//  FridgeRecipeFinder
//
//  Created by Ezra Akresh on 12/2/24.
//

import SwiftUI

struct ContentView: View {
    /// ContentView Properties
    @State private var showScanner: Bool = false
    @State private var scannedCode: String = ""
    @State private var product: Product? = nil
    
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
            /// Implement logic to open new view to show more detailed information about product
            fetchProductData()
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
                DispatchQueue.main.async {
                    product = decodedData.product
                }
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
