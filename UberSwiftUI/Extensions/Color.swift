//
//  Color.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/13/22.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}


struct ColorTheme {
    let primaryTextColor = Color("PrimaryTextColor")
    let backgroundColor = Color("BackgroundColor")
    let secondaryBackgroundColor = Color("SecondaryBackgroundColor")
    let systemBackgroundColor = Color("SystemBackgroundColor")
}
