//
//  WeatherView.swift
//

import SwiftUI

struct WeatherView: View {
    @Environment(WeatherModel.self) private var weatherModel

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("ColorF8B6BF"), Color("ColorDEBDD1"), Color("ColorD0C2DA"), Color("ColorC5CDE6"), Color("ColorD9D8EA")], startPoint: .top, endPoint: .bottom)
            Text("weather view")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    WeatherView()
}
