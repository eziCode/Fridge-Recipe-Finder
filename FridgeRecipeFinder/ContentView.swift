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
                            ScannerView(showScanner: $showScanner)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
}

#Preview {
    ContentView()
}
