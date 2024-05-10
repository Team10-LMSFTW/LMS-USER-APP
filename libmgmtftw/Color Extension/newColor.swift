//
//  color.swift
//  libmgmtftw
//
//  Created by Anvit Pawar on 29/04/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0

        scanner.scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
