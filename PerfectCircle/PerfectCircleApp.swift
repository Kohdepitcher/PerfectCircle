//
//  PerfectCircleApp.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 27/10/2023.
//

import SwiftUI

@main
struct PerfectCircleApp: App {
    
    @State private var appSettings = AppSettings()
    @State private var drawingModel = DrawingModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appSettings, self.appSettings)
                .environment(\.drawingModel, self.drawingModel)
                .preferredColorScheme(.dark)
        }
    }
}
