//
//  RoundedShape.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/24/21.
//

import SwiftUI

struct RoundedShape: Shape {
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 32, height: 32))
        return Path(path.cgPath)
    }
}
