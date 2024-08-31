//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {
    @State private var showingWeatherView: Bool = false
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(colors: [Color("blue"), Color("blue 1"), Color("blue 2"), Color("blue 3")], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack {
                    HStack {
                        Text("CO2")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        Spacer()
                        Button {

                        } label: {
                            Image(systemName: "sensor")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.1, height: proxy.size.width * 0.1)
                                .foregroundStyle(.white)
//                                .background(.ultraThinMaterial)
                                
                        }
                        .frame(width: proxy.size.width * 0.2, height: proxy.size.width * 0.15)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.size.width * 0.2)

                    Button {
                        showingWeatherView = true
                    } label: {
                        weatherWidgetView(proxy: proxy)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: proxy.safeAreaInsets.bottom, alignment: .top)
                .padding()
                .sheet(isPresented: $showingWeatherView) {
                    WeatherView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func weatherWidgetView(proxy: GeometryProxy) -> some View {
        HStack {
            Image(systemName: "cloud.sun.fill")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width * 0.15)
            VStack(alignment: .leading, spacing: 0) {
                Text("Tokyo")
                Text("sunny")
            }
            .font(.title3)
            .foregroundStyle(.white)
            Spacer()
            Text("28˚")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 64)
        .padding(.horizontal, 16)
        .font(.title2)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}
