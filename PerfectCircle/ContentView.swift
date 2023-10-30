//
//  ContentView.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 27/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.appSettings) private var appSettings
    @Environment(\.drawingModel) private var drawingModel
    
    /// Properties
    @State private var showingSettingsSheet = false
    @State var showingIntro = true

 
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
                RadialGradient(gradient: Gradient(colors: [Color(red: 0, green: 0, blue: 0), Color(red: 30/255, green: 30/255, blue: 30/255)]),
                               center: .center,
                               startRadius: 0,
                               endRadius: min(drawingModel.frameSize.width, drawingModel.frameSize.height)
                              )
            )
            
            //        .frame(width: frameSize.width, height: frameSize.height, alignment: .center)
            
            .onAppear {
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.drawingModel.playDemoDrawingAnimation()
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
            
//            /// Play error haptic feedback when drawing is disabled.
//            /// Will happen when the user failed a check in their drawing.
//            .sensoryFeedback(.error, trigger: !drawingModel.canDraw)
//            
//            .sensoryFeedback(.success, trigger: drawingModel.isValid)
            
            .disabled(showingIntro)
            
            .overlay(alignment: .center) {
                
                
                Circle()
                    .fill(.white)
                    .frame(width: 20)
                
                HStack(alignment: .bottom, spacing: 0) {
                    
                    
                    
                    Text("\(drawingModel.score != 0 ? String(format: "%g", Double(drawingModel.score / 10)) : "XX")")
                        .monospacedDigit()
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .bold()
                        .foregroundStyle(drawingModel.scoreColor)
                    
                    Spacer()
                        .frame(width: 35)
                    
                    Text("\(drawingModel.score != 0 ? String(format: "%g", Double(Double(drawingModel.score) * 0.1).truncatingRemainder(dividingBy: 1) * 10) : "X")%")
                        .monospacedDigit()
                        .font(.title)
                        .fontDesign(.rounded)
                        .bold()
                        .foregroundStyle(drawingModel.scoreColor)
                    
                }
                .padding(.bottom, 5)
                
                Text(drawingModel.message)
                    .font(.title)
                    .bold()
                    .shadow(radius: 10)
                    .padding(.top, 100)
                    
                if !drawingModel.scoreMessage.isEmpty {
                    Text(drawingModel.scoreMessage)
                        .font(.title)
                        .bold()
                        .shadow(radius: 10)
                        .padding(.top, 100)
                        .blinking(duration: 0.6)
                }
                
                VStack(spacing: 50) {
                    
                    Text("Draw a cirlce")
                    Text("around this")
                    
                }
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontDesign(.rounded)
                .bold()
                .opacity(showingIntro ? 0 : (drawingModel.hasDrawn ? 0 : 1))
                
                
                
                Text("Can you draw a \n PERFECT CIRCLE?")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .bold()
                    .opacity(showingIntro ? 1 : 0)
                    .padding(.bottom, 250)
                    
                
                
                Button(action: {
                    drawingModel.stopDemoAnimation()
                    withAnimation(.spring) {
                        showingIntro = false
                    }
                }) {
                    Text("GO")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.black)
                        .padding()
                        .opacity(showingIntro ? 1 : 0)
                }
                .buttonBorderShape(.circle)
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .scaleEffect(showingIntro ? CGSize(width: 1.0, height: 1.0) : CGSize.zero, anchor: .center)
            }
            
            VStack(alignment: .center, spacing: 20) {
                
                HStack {
                    
                    Spacer()
                    
                    Text("PERFECT CIRCLE")
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .bold()
                    
                    Spacer()
                }
                
                Text("Personal Best: ")
                    .monospacedDigit()
                    .font(.title2)
                    .fontDesign(.rounded)
                    .bold()
                +
                Text("\(String(format: "%g", Double(drawingModel.bestScore) * 0.1))%")
                    .monospacedDigit()
                    .font(.title2)
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundStyle(colorForAccuracy(accuracy: Double(drawingModel.bestScore) * 0.001))
                
                Spacer()
                
            }
            .overlay(alignment: .topLeading) {
                Button(action: { showingSettingsSheet.toggle() }) {
                    Image(systemName: "gearshape.fill")
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .bold()
                }
                .tint(.white)
                .padding(.leading)
                .sheet(isPresented: $showingSettingsSheet) {
                    SettingsView()
                        .preferredColorScheme(.dark)
                }
            }
            .opacity(showingIntro ? 0 : 1)
            .padding(.top)
            
        }
        
        .onChange(of: drawingModel.bestScore) {
            appSettings.bestScore = drawingModel.bestScore
        }
        
    }
    
    
}

#Preview {
    ContentView()
        .environment(\.appSettings, AppSettings())
        .environment(\.drawingModel, DrawingModel())
}


struct Point {
    var point: CGPoint
    var color: Color
    var stroke: CGFloat
}


//MARK: - Collection Extensions
extension Collection {
    
    //https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
