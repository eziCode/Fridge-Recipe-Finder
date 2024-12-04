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
                print("scanned code: ", scannedCode)
            }
        }
}

#Preview {
    ContentView()
}
