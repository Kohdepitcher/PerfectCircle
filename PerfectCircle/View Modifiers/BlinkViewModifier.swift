//
//  BlinkViewModifier.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 29/10/2023.
//

/// Sourced from: https://stackoverflow.com/questions/59015929/button-blink-animation-with-swiftui

import Foundation
import SwiftUI

struct BlinkViewModifier: ViewModifier {
    
    let duration: Double
    @State private var blinking: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0 : 1)
            .animation(.easeInOut(duration: duration).repeatCount(5), value: blinking)
        
            .onAppear {
 
                withAnimation {
                    blinking = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    blinking = false
                }
            }
    }
}

extension View {
    func blinking(duration: Double = 0.75) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
}


/*
 // with duration

 Text("Hello, World!")
     .foregroundColor(.white)
     .padding()
     .background(Color.blue)
     .blinking(duration: 0.75) // here duration is optional. This is blinking time

 // or (default is 0.75)

 Text("Hello, World!")
     .foregroundColor(.white)
     .padding()
     .background(Color.blue)
     .blinking()
 */
