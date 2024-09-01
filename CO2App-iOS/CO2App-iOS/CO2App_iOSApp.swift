//
//  CO2App_iOSApp.swift
//

import SwiftUI

@main
struct CO2App_iOSApp: App {
    @State private var weatherModel = WeatherModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(weatherModel)
        }
    }
}
