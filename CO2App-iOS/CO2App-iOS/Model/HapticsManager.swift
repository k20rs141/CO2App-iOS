//
//  HapticsManager.swift
//

import UIKit

enum FeedbackType: Int {
    case success
    case failure
    case error

    var value: UINotificationFeedbackGenerator.FeedbackType {
        return .init(rawValue: rawValue) ?? .error
    }
}

@MainActor
final class HapticsManager {
    static let shared = HapticsManager()
    private let generator = UINotificationFeedbackGenerator()

    func feedback(type: FeedbackType) {
        generator.prepare()
        generator.notificationOccurred(type.value)
    }
}
