//
//  ContentView.swift
//  Project Health
//
//  Created by Joseph Gaza
//

import SwiftUI

struct ContentView: View {
    // This will track the loading screen. Then move to the next page
    @State private var isLoading = false
    
    var body: some View {
        if isLoading {
            AccountView()
        }
        else {
        ZStack  {
            Color.red
                .ignoresSafeArea()
            VStack {
                
                Image(systemName: "heart")
                    .imageScale(.large)
                    .foregroundColor(.white)
                Text(" ")
                Text("Project Health").font(.body).bold().foregroundColor(.white)
                }
            }
        // This will automatically execute code
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    isLoading = true
                }
            }
        }
        }
    }
}

#Preview {
    ContentView()
}
