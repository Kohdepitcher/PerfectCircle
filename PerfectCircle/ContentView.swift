//
//  ContentView.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 27/10/2023.
//

import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    
    @Environment(\.appSettings) private var appSettings
    @Environment(\.drawingModel) private var drawingModel
    
    /// Properties
    @State private var showingSettingsSheet = false
    @State var showingIntro = true
    
    @State private var confettiCounter = 0
    
    @State var capture: CGImage?

 
    var body: some View {
        
        ZStack {
            
            DrawingView()
            
            .background(
                ZStack {
                    
//                    Image("background")
//                        .resizable(resizingMode: .tile)
                        
                    
                    RadialGradient(gradient: Gradient(colors: [Color(red: 0, green: 0, blue: 0), Color(red: 30/255, green: 30/255, blue: 30/255)]),
                                   center: .center,
                                   startRadius: 0,
                                   endRadius: min(drawingModel.frameSize.width, drawingModel.frameSize.height)
                    )
//                    .opacity(0.5)
                    
//                    Color.white
                    
                    
                }
                .ignoresSafeArea()
                
            )
            
//            /// Play error haptic feedback when drawing is disabled.
//            /// Will happen when the user failed a check in their drawing.
//            .sensoryFeedback(.error, trigger: !drawingModel.canDraw)
//            
//            .sensoryFeedback(.success, trigger: drawingModel.isValid)
            
            /// When the drawing canvas appears, start the intro drawing animation
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.drawingModel.playDemoDrawingAnimation()
                }
            }
            
            .disabled(showingIntro)
            
            .overlay(alignment: .center) {
                
                
                
                
//                Circle()
//                    .trim(from: 0.0, to: CGFloat(1.0))
//                        .stroke(Color.red, lineWidth: 10)
//                        .frame(width: 330, height: 330)
                
//                HStack(alignment: .bottom, spacing: 0) {
//                    
//                    
//                    
//                    Text("\(drawingModel.score != 0 ? String(format: "%g", Double(drawingModel.score / 10)) : "XX")")
//                        .monospacedDigit()
////                        .font(.largeTitle)
//                        .font(.system(size: 55))
//                        .fontDesign(.rounded)
//                        .bold()
//                        .foregroundStyle(drawingModel.scoreColor)
//                    
//                    Spacer()
//                        .frame(width: 24)
//                    
//                    Text("\(drawingModel.score != 0 ? String(format: "%g", Double(Double(drawingModel.score) * 0.1).truncatingRemainder(dividingBy: 1) * 10) : "X")%")
//                        .monospacedDigit()
////                        .font(.title)
//                        .font(.system(size: 45))
//                        .fontDesign(.rounded)
//                        .bold()
//                        .foregroundStyle(drawingModel.scoreColor)
//                    
//                }
//                .padding(.bottom, 20)
                
                Text(drawingModel.message)
                    .font(.title)
                    .bold()
//                    .shadow(radius: 10)
                    .strokeBorder(color: .black, lineWidth: 3)
                    .padding(.top, 100)
                    

                
                VStack(spacing: 70) {
                    
                    Text("Draw a circle")
                    Text("around this")
                    
                }
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontDesign(.rounded)
                .bold()
                .strokeBorder(color: .black, lineWidth: 3)
                .opacity(showingIntro ? 0 : (drawingModel.hasDrawn ? 0 : 1))
                
                
                
                Text("Can you draw a \n PERFECT CIRCLE?")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontDesign(.rounded)
                    .bold()
                    .strokeBorder(color: .black, lineWidth: 3)
                    .opacity(showingIntro ? 1 : 0)
                    .padding(.bottom, 250)
//                    .glowBorder(color: Color.black, lineWidth: 10)
                    
                    
                
                    
                
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
                
                
//                Image(systemName: "hand.point.up.fill")
//                    .font(.largeTitle)
//                    .offset(x: 150)
                
                
                
                
            }
            
            VStack(alignment: .center, spacing: 10) {
                
                scoreLabel()
                
                
                if !drawingModel.scoreMessage.isEmpty {
                    Text(drawingModel.scoreMessage)
                        .font(.title)
                        .bold()
//                        .shadow(radius: 10)
//                        .padding(.top, 100)
                        .blinking(duration: 0.6)
                        .strokeBorder(color: .black, lineWidth: 3)
                }
                
                Spacer()
                
            }
            
            
            .safeAreaInset(edge: .top) {
                
                ZStack {
                    
                    HStack {
                        Button(action: { showingSettingsSheet.toggle() }) {
                            Image(systemName: "gearshape.fill")
                                .font(.largeTitle)
                                .fontDesign(.rounded)
                                .bold()
                                .strokeBorder(color: .black, lineWidth: 3)
                        }
                        
                        .tint(.white)
                        .padding(.leading)
                        .sheet(isPresented: $showingSettingsSheet) {
                            SettingsView()
                                .preferredColorScheme(.dark)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        
                        Spacer()
                        
                        //                    Text("PERFECT CIRCLE")
                        //                        .font(.largeTitle)
                        //                        .fontDesign(.rounded)
                        //                        .bold()
                        //                        .glowBorder(color: Color.black, lineWidth: 10)
                        HStack {
                            Text("Your Best - ")
                                .monospacedDigit()
                                .font(.title2)
                                .fontDesign(.rounded)
                                .bold()
                            +
                            Text("\(String(format: "%g", Double(drawingModel.bestScore) * 0.1))%")
                            
                                .font(Font.custom("Retro", size: 20, relativeTo: .body))
                            
                            //                    .monospacedDigit()
                            //                    .font(.title2)
                            //                    .fontDesign(.rounded)
                            //                    .bold()
                                .foregroundStyle(colorForAccuracy(accuracy: Double(drawingModel.bestScore) * 0.001))
                        }
                        .strokeBorder(color: .black, lineWidth: 3)
                        
                        Spacer()
                    }
                    
                }
                
            }
            .opacity(showingIntro ? 0 : 1)
            .padding(.top)
            
//            .safeAreaInset(edge: .bottom) {
//                if let capture {
//                    ShareLink(item: Image(uiImage: UIImage(cgImage: capture)), preview: SharePreview("Perfect Circle", image: Image(uiImage: UIImage(cgImage: capture))))
//                }
//            }
            
        }
        
        .onChange(of: drawingModel.bestScore) {
            appSettings.bestScore = drawingModel.bestScore
            
            if drawingModel.bestScore > confettiCounter {
                self.confettiCounter = drawingModel.bestScore
                
//                capture = ImageRenderer(content: 
//                                            ScreenshotCopyView()
//                                            .environment(\.drawingModel, self.drawingModel)
//                ).cgImage
            }
            
            
        }
        
//        .onChange(of: drawingModel.isDrawing) {
//            if drawingModel.isDrawing {
//                capture = nil
//            }
//        }
        
        .confettiCannon(counter: self.$confettiCounter)
        
    }
    
    
    @ViewBuilder
    func scoreLabel() -> some View {
        HStack {
            Text("\(drawingModel.score != 0 ? String(format: "%g", Double(drawingModel.score / 10)) : "XX")")
                .monospacedDigit()
            //                        .font(.largeTitle)
            //                    .font(.system(size: 55))
            //                    .fontDesign(.rounded)
            //                    .bold()
                .font(Font.custom("Retro", size: 55, relativeTo: .body))
                .foregroundStyle(drawingModel.scoreColor)
            
            +
            
            Text("\(drawingModel.score != 0 ? String(format: ".%g", Double(Double(drawingModel.score) * 0.1).truncatingRemainder(dividingBy: 1) * 10) : ".X")%")
                .monospacedDigit()
            //                        .font(.title)
            //                    .font(.system(size: 45))
            //                    .fontDesign(.rounded)
            //                    .bold()
                .font(Font.custom("Retro", size: 30, relativeTo: .body))
                .foregroundStyle(drawingModel.scoreColor)
        }
        .strokeBorder(color: .black, lineWidth: 3 )
        
        /// Only add line width if the score is a high score.
        /// If it's a high score, then use the same scoreColor as an outer glow.
        .glowBorder(color: drawingModel.scoreColor, lineWidth: drawingModel.scoreMessage.isEmpty ? 0 : 5)
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
    var accuracy: CGFloat
}


//MARK: - Collection Extensions
extension Collection {
    
    //https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
