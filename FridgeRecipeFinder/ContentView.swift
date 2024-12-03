//
//  ContentView.swift
//  FridgeRecipeFinder
//
//  Created by Ezra Akresh on 12/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    
    var body: some View {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    HStack {
                        Button(action: {
                            openCamera()
                        }) {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                        }
                        
                    }
                    Spacer()
                }
                .padding()
            }
        }
}

#Preview {
    ContentView()
}

func openCamera() {
    print("hello")
}
