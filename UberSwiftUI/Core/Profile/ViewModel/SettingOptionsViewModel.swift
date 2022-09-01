//
//  SettingsItemViewModel.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/29/21.
//

import SwiftUI

enum SettingOptionsViewModel: Int, CaseIterable {
    case notifications
    case paymentMethods
    
    var title: String {
        switch self {
        case .notifications: return "Notifications"
        case .paymentMethods: return "Payment Methods"
        }
    }
    
    var imageName: String {
        switch self {
        case .notifications: return "bell.circle.fill"
        case .paymentMethods: return "creditcard.circle.fill"
        }
    }
    
    var imageBackgroundColor: UIColor {
        switch self {
        case .notifications: return .systemRed
        case .paymentMethods: return .systemBlue
        }
    }
}
