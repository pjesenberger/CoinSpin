//
//  ContentView.swift
//  CoinSpin
//
//  Created by Pascal Jesenberger on 04/06/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var spinTrigger = 0
    @State private var rotation = 0.0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(red: 31 / 255, green: 31 / 255, blue: 31 / 255)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 4) {
                CoinSpin(imageName: "Bitcoin", edgeColor: UIColor(red: 0xCF / 255, green: 0x54 / 255, blue: 0x12 / 255, alpha: 1), spinTrigger: spinTrigger)
                    .frame(width: 80, height: 80)
                    .onTapGesture { spinTrigger += 1 }
                
                HStack(spacing: 4) {
                    Text("Bitcoin")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    
                    Image(systemName: "seal.fill")
                        .foregroundStyle(.blue)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .rotationEffect(.degrees(rotation))
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 9.6, weight: .heavy, design: .rounded))
                        )
                }
                .padding(.top, 2)
                
                Text("$64,472.83")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding()
            .padding(.top, 10)
        }
        .onAppear {
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    ContentView()
}
