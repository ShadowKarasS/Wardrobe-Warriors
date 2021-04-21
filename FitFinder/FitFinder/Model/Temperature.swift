//
//  Temperature.swift
//  FitFinder
//
//  Created by Noah Frew on 4/6/21.
//

import Foundation
 
enum Temperature: String {
    case veryCold
    case cold
    case mild
    case hot
    case veryHot
    
    var emoji: String {
        switch self {
        case .veryCold:
            return "❄️"
        case .cold:
            return "☁️"
        case .mild:
            return "🌥"
        case .hot:
            return "🌤"
        case .veryHot:
            return "🔥"
        }
    }
}
