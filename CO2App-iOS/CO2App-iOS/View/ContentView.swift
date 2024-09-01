//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {
    @Environment(WeatherModel.self) private var weatherModel
    @State private var isPresented: Bool = false

    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
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
                                Image(systemName: "bell")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.width * 0.1, height: proxy.size.width * 0.1)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: proxy.size.width * 0.15, height: proxy.size.width * 0.15)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            Button {
                                isPresented = true
                            } label: {
                                Image(systemName: "sensor")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.width * 0.1, height: proxy.size.width * 0.1)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: proxy.size.width * 0.2, height: proxy.size.width * 0.15)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .navigationDestination(isPresented: $isPresented) {
                                BLEConnectingView(screenSize: proxy.size)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: proxy.size.width * 0.2)

                        NavigationLink(destination: WeatherView()) {
                            weatherWidgetView(screenSize: proxy.size)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: proxy.safeAreaInsets.bottom, alignment: .top)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onAppear {
                    weatherModel.updateWeather()
                }
            }
        }
    }

    @ViewBuilder
    private func weatherWidgetView(screenSize: CGSize) -> some View {
        HStack(spacing: 18) {
            if let weather = weatherModel.weather {
                Image(systemName: "\(weather.currentWeather.symbolName).fill")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenSize.width * 0.1)
                VStack(alignment: .leading, spacing: 0) {
                    Text(weatherModel.locationName)
                    Text(weather.currentWeather.condition.description)
                }
                .font(.title3)
                .foregroundStyle(.white)
                Spacer()
                Text("\(Int(weather.currentWeather.temperature.value.rounded()))°")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            } else {
                ProgressView()
            }
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
        .environment(WeatherModel())
}
