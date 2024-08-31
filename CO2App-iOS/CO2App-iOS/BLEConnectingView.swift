//
//  BLEConnectingView.swift
//

import SwiftUI
import Combine

struct BLEConnectingView: View {
    @State private var shouldAnimate: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 128, height: 128)
                    .overlay(
                        ZStack {
                            Circle()
                                .fill(.ultraThickMaterial)
                                .scaleEffect(shouldAnimate ? 1.5 : 0)
                                .opacity(shouldAnimate ? 0.0 : 0.4)
                            Circle()
                                .fill(.ultraThickMaterial)
                                .scaleEffect(shouldAnimate ? 2 : 0)
                                .opacity(shouldAnimate ? 0.0 : 0.9)
                            Circle()
                                .fill(.ultraThickMaterial)
                                .scaleEffect(shouldAnimate ? 3 : 0)
                                .opacity(shouldAnimate ? 0.0 : 0.7)
                            
                        }
                            .animation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: false), value: shouldAnimate)
                    )
                Image(systemName: "personalhotspot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(Color("blue 2"))
                
            }
            HStack {
                LoadingAnimation(color: .white)
                Text("検索中")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Text("しばらくお待ち下さい")
                .foregroundStyle(.secondary)
                .font(.callout)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [Color("blue"), Color("blue 1"), Color("blue 2"), Color("blue 3")], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .ignoresSafeArea()
        .onAppear {
            self.shouldAnimate = true
        }
    }
}

#Preview {
    BLEConnectingView()
}
