//
//  FitFinderColors.swift
//  FitFinder
//
//  Created by Noah Frew on 4/17/21.
//

import Foundation
import SwiftUI

enum FitFinderColors {
    case yellowColor, blueColor, creamColor, peachColor
    
    var color: Color {
        switch self {
        case .yellowColor:
            return Color(red: 221/255, green: 184/255, blue: 106/255)
        case .blueColor:
            return Color(red: 155/255, green: 174/255, blue: 191/255)
        case .creamColor:
            return Color(red: 233/255, green: 215/255, blue: 195/255)
        case .peachColor:
            return Color(red: 228/255, green: 169/255, blue: 135/255)
        }
    }
}
