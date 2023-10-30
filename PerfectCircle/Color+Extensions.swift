//
//  Color+Extensions.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 29/10/2023.
//

import Foundation
import SwiftUI

//extension Color {
    
    func colorForAccuracy(accuracy: CGFloat) -> Color {
        
        var e = 480 * (accuracy - 0.75)
        
        /// Clamp between 0 and 120 as this gets us the hues between green and red (green, yellow, orange, red)
        e = min(e, 120)
        e = max(e, 0)
        
        
        let hue = e / 360
        let saturation = 1.0
        let brightness = accuracy + 0.8
        
        
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
//}
