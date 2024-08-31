//
//  WeatherModel.swift
//

import CoreLocation
import Foundation
import Observation
import WeatherKit

@MainActor @Observable
final class WeatherModel: NSObject, CLLocationManagerDelegate {
    static let shared = WeatherModel()

    var weather: Weather? = nil
    var locationName: String = ""
    var errorMessage: String = ""

    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation? = CLLocation(latitude: 35.6894, longitude: 139.692) // 東京都

    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    func updateWeather() {
        guard let userLocation = self.userLocation else { return }
        Task.detached(priority: .background) {
            do {
                let weather = try await WeatherService.shared.weather(for: userLocation)
                Task { @MainActor in
                    self.weather = weather
                    print("weather: \(String(describing: self.weather))")
                }
            } catch {
                Task { @MainActor in
                    self.errorMessage = "天気が取得できませんでした"
                }
                print(error.localizedDescription)
            }
        }
    }

    nonisolated private func reverseGeocoding(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let firstPlacemark = placemarks?.first {
                var placeName = ""
                // 都道府県
                if let prefectures = firstPlacemark.administrativeArea {
                    placeName.append(prefectures)
                }
                // 市区町村
                if let municipalities = firstPlacemark.locality {
                    placeName.append(municipalities)
                }
                Task { @MainActor in
                    self.locationName = placeName
                }
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        reverseGeocoding(location: location)
        Task { @MainActor in
            userLocation = location
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        // ユーザーが位置情報を選択してない場合
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        // ペアレンタルコントロールなどの制限がかかっている場合
        case .restricted:
            manager.requestLocation()
        // ユーザーが設定から位置情報を許可してない場合
        case .denied:
            manager.requestWhenInUseAuthorization()
        // ユーザーが位置情報を許可している場合
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        default: break
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

    }
}
