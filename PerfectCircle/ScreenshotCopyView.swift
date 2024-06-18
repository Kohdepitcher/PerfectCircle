//
//  ScreenshotCopyView.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 4/2/2024.
//

import SwiftUI

struct ScreenshotCopyView: View {
    
//    public var drawingModel: DrawingModel
    
    public let points: [Point]
    public let score: Int
    public let scoreColor: Color
    
    enum AppIconProvider {
        static func appIcon(in bundle: Bundle = .main) -> String {

            guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],

                  let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],

                  let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],

                  let iconFileName = iconFiles.last else {
                fatalError("Could not find icons in bundle")
            }

            return iconFileName
        }
    }
    
    var body: some View {
        
        GeometryReader { geoReader in
            
            ZStack {
                
                Canvas { context, size in
                    
                    for (index, point) in points.enumerated() {
                        
                        let centerX = point.point.x - point.stroke / 2
                        let centerY = point.point.y - point.stroke / 2
                        
                        let path = Path(ellipseIn: CGRect(x: centerX, y: centerY, width: point.stroke, height: point.stroke))
                        
                        context.fill(path, with: .color(point.color))
                        
                        if let previousPoint = points[safe: index - 1] {
                            
                            var linePath = Path()
                            
                            linePath.addLines([previousPoint.point, point.point])
                            
                            context.stroke(linePath, with: .color(point.color), style: StrokeStyle(lineWidth: previousPoint.stroke, lineCap: .round, lineJoin: .round))
                        }
                        
                        
                    }
                    
                    
                }
                
                            .background(
                                ZStack {
                
                                    //                    Image("background")
                                    //                        .resizable(resizingMode: .tile)
                
                
                                    RadialGradient(gradient: Gradient(colors: [Color(red: 0, green: 0, blue: 0), Color(red: 30/255, green: 30/255, blue: 30/255)]),
                                                   center: .center,
                                                   startRadius: 0,
                                                   endRadius: min(geoReader.size.width, geoReader.size.height)
                                    )
                                    //                    .opacity(0.5)
                
                                    //                    Color.white
                
                
                                }
                                    .ignoresSafeArea()
                
                            )
                
                Circle()
                    .fill(.white)
                    .frame(width: 20)
                
                
                VStack {
                    
                    HStack {
                        Text("\(score != 0 ? String(format: "%g", Double(score / 10)) : "XX")")
                            .monospacedDigit()
                        //                        .font(.largeTitle)
                        //                    .font(.system(size: 55))
                        //                    .fontDesign(.rounded)
                        //                    .bold()
                            .font(Font.custom("Retro", size: 55, relativeTo: .body))
                            .foregroundStyle(scoreColor)
                        
                        +
                        
                        Text("\(score != 0 ? String(format: ".%g", Double(Double(score) * 0.1).truncatingRemainder(dividingBy: 1) * 10) : ".X")%")
                            .monospacedDigit()
                        //                        .font(.title)
                        //                    .font(.system(size: 45))
                        //                    .fontDesign(.rounded)
                        //                    .bold()
                            .font(Font.custom("Retro", size: 30, relativeTo: .body))
                            .foregroundStyle(scoreColor)
                    }
                    .strokeBorder(color: .black, lineWidth: 3 )
                    
                    .padding(.top, 60)
                    
                    Spacer()
                    
                }
            }
            //        .frame(width: drawingModel.frameSize.width, height: drawingModel.frameSize.height)
            
            
            .overlay(alignment: .bottom) {
                    
                VStack {
                    
                    HStack(alignment: .center, spacing: 12) {
                        
                        
                        if let image = UIImage(named: AppIconProvider.appIcon()) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .strokeBorder(color: .white, lineWidth: 1)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Can you draw a \n PERFECT CIRCLE?")
                                .multilineTextAlignment(.leading)
                                .font(.title)
                                .fontDesign(.rounded)
                                .bold()
                                .foregroundStyle(.white)
                                .strokeBorder(color: .black, lineWidth: 3)
                        }
                        .drawingGroup()
                        
                    }
                    
                    .fixedSize()
                    
                    Text("An app by Kohde Pitcher")
                        .fontDesign(.rounded)
                        .bold()
                        .foregroundStyle(.white)
                        .strokeBorder(color: .black, lineWidth: 3)
                }
                .padding(.bottom, 60)
                
                
                
                .background(
                    LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top)
                        .frame(width: geoReader.size.width)
                        .ignoresSafeArea()
                )

            }
            
            
        }
        
        
    }
}

#Preview {
    
//    let model = DrawingModel()
    
    return ScreenshotCopyView(points: [], score: 999, scoreColor: .green)
}
