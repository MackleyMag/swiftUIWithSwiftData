//
//  Color+Hex.swift
//  PlayingWithSwiftData
//
//  Created by Mackley Magalhães da Silva on 22/05/24.
//

import SwiftUI


extension Color {

    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self.init(uiColor: uiColor)
    }

    func toHexString(includeAlpha: Bool = false) -> String? {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }

}
