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
        .onAppear {
            sendDeviceIdentifierToServer()
        }
    }
    
    func sendDeviceIdentifierToServer() {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        guard let url = URL(string: "http://192.168.40.68:3000/registerDevice") else {
            print("Server not online")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["userId": uuid]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize body")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to send device identifier: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Unexpected response from server")
                return
            }
        }
        task.resume()
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
