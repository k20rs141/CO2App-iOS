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
                ScrollView {
                    VStack {
                        HStack {
                            Text("CO2")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: proxy.size.width * 0.2)

                        NavigationLink(destination: WeatherView()) {
                            weatherWidgetView(screenSize: proxy.size)
                        }
                        NavigationLink(destination: WeatherView()) {
                            co2CardView(screenSize: proxy.size)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(.backgroundPrimary)
                .onAppear {
                    weatherModel.updateWeather()
                }
                .navigationTitle("ホーム")
                .toolbarBackground(.blue, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "bell")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isPresented = true
                        } label: {
                            Image(systemName: "sensor")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                        }
                        .navigationDestination(isPresented: $isPresented) {
                            BLEConnectingView(screenSize: proxy.size)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func weatherWidgetView(screenSize: CGSize) -> some View {
        if let weather = weatherModel.weather {
            VStack(spacing: 16) {
                HStack(spacing: 18) {
                    Image(systemName: "\(weather.currentWeather.symbolName).fill")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenSize.width * 0.2)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(weather.currentWeather.condition.description)
                        Text(weatherModel.locationName)
                    }
                    .font(.title3)
                    .foregroundStyle(.white)
                    Spacer()
                    Text("\(Int(weather.currentWeather.temperature.value.rounded()))°")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
                HStack(spacing: 18) {
                    ForEach(CurrentWeather.allCases, id: \.self) { value in
                        VStack {
                            Text(value.title)
                            switch value {
                            case .humidity:
                                Text("\(weather.currentWeather.humidity)")
                            case .precipitation:
                                Text("\(weather.currentWeather.precipitationIntensity.value)")
                            case .wind:
                                Text("\(weather.currentWeather.wind.speed.value)")
                            }
                        }
                        .modifyText(color: .white, fontSize: 16, fontWeight: .regular)
                        Spacer()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .modifyCardView(backgroundColor: .backgroundSecondary, cornerRadius: 16)
            //        .background(.ultraThinMaterial)
        } else {
            ProgressView()
        }
    }

    @ViewBuilder
    private func co2CardView(screenSize: CGSize) -> some View {
        HStack {
            VStack {
                HStack {
                    Circle()
                        .fill()
                        .frame(width: 16, height: 16)
                    Text("今日のCO2")
                }
                Text("最終更新日")
                HStack {
                    VStack {
                        Text("25")
                        
                    }
                }
            }
        }
        .padding()
        .modifyCardView(backgroundColor: .backgroundSecondary, cornerRadius: 16)
    }
}

#Preview {
    ContentView()
        .environment(WeatherModel())
}

enum CurrentWeather: Int, CaseIterable {
    case humidity = 0
    case precipitation
    case wind

    var title: String {
        switch self {
        case .humidity:
            "湿度"
        case .precipitation:
            "降水量"
        case .wind:
            "風速"
        }
    }
}
