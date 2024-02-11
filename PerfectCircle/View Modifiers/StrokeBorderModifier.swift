//
//  StrokeBorderModifier.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 4/2/2024.
//

import Foundation
import SwiftUI

struct StrokeBorderModifier: ViewModifier {
    
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize * 2)
            .background(
                Rectangle()
                    .foregroundStyle(strokeColor)
                    .mask({
                        outline(context: content)
                    })
            )
            
    }
    
    func outline(context: Content) -> some View {
        
        Canvas { context, size in
            
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: CGPoint(x: size.width/2, y: size.height/2))
                }
                
            }
            
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
        
    }
}

extension View {
    func strokeBorder(color: Color, lineWidth: CGFloat) -> some View {
        modifier(StrokeBorderModifier(strokeSize: lineWidth, strokeColor: color))
    }
}
