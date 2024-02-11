//
//  DrawingView.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 4/2/2024.
//

import SwiftUI

struct DrawingView: View {
    
    @Environment(\.drawingModel) private var drawingModel
    
    var body: some View {
        
        ZStack {
            
            Canvas { context, size in
                
                for (index, point) in drawingModel.points.enumerated() {
                    
                    let centerX = point.point.x - point.stroke / 2
                    let centerY = point.point.y - point.stroke / 2
                    
                    let path = Path(ellipseIn: CGRect(x: centerX, y: centerY, width: point.stroke, height: point.stroke))
                    
                    context.fill(path, with: .color(point.color))
                    
                    if let previousPoint = drawingModel.points[safe: index - 1] {
                        
                        var linePath = Path()
                        
                        linePath.addLines([previousPoint.point, point.point])
                        
                        context.stroke(linePath, with: .color(point.color), style: StrokeStyle(lineWidth: previousPoint.stroke, lineCap: .round, lineJoin: .round))
                    }
                    
                    
                }
                
                
            }
            
            
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            drawingModel.frameSize = proxy.size
                        }
                }
            )
            
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                
                    .onChanged({ value in
                        drawingModel.drawStart(dragValue: value)
                        drawingModel.drawMove(dragValue: value)
                    })
                
                    .onEnded({ value in
                        drawingModel.drawEnd(dragValue: value)
                    })
                
            )
            
            Circle()
                .fill(.white)
                .frame(width: 20)
            
        }
        
    }
}

#Preview {
    DrawingView()
}
