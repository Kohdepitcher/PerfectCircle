//
//  SettingsView.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 29/10/2023.
//

import SwiftUI
import Setting

struct SettingsView: View {
    
    @Environment(\.appSettings) private var appSettings
    @Environment(\.drawingModel) private var drawingModel
    
    @State private var showingResetWarning = false
    
    var body: some View {
        
        SettingStack(isSearchable: false) {
            
            SettingPage(title: "") {
                
//                SettingGroup() {
                    SettingCustomView {
                        HStack {
                            
                            Spacer()
                            
                            Text("PERFECT CIRCLE")
                                .multilineTextAlignment(.center)
                                .font(.largeTitle)
                                .fontDesign(.rounded)
                                .bold()
                                .strokeBorder(color: .black, lineWidth: 3)
                                .padding()
                            
                            Spacer()
                        }
//                            .background(.black)
//                            .padding(.bottom)
                    }
//                }
                
                SettingGroup() {
                    SettingCustomView {
                        
                        VStack {
                            
                            
                            
                            HStack {
                                Text("Original web game by Matt Round and Neal Agarwal")
                            }
                            .bold()
                            .font(.title3)
                                
                        }
                        .padding()
                        
                    }
                    
                    SettingButton(title: "View original web game") {
                        if let url = URL(string: "https://neal.fun/perfect-circle/") {
                            #if os(iOS)
                            UIApplication.shared.open(url)
                            #else
                            NSWorkspace.shared.open(url)
                            #endif
                        }
                    }
                    
                    SettingButton(title: "Matt Rounds's Twitter") {
                        if let url = URL(string: "https://twitter.com/mattround") {
                            #if os(iOS)
                            UIApplication.shared.open(url)
                            #else
                            NSWorkspace.shared.open(url)
                            #endif
                        }
                    }
                    
                    SettingButton(title: "Neal Agarwal's Twitter") {
                        if let url = URL(string: "https://twitter.com/nealagarwal") {
                            #if os(iOS)
                            UIApplication.shared.open(url)
                            #else
                            NSWorkspace.shared.open(url)
                            #endif
                        }
                    }
                    
                }
                
                SettingGroup() {
                    
                    SettingButton(title: "Built by Kohde Pitcher") {
                        if let url = URL(string: "https://kohdepitcher.com") {
                            #if os(iOS)
                            UIApplication.shared.open(url)
                            #else
                            NSWorkspace.shared.open(url)
                            #endif
                        }
                    }
                    
                }
                
                SettingGroup {
                    
//                    let hapticbinding = Binding(get: { appSettings.hapticFeedbackEnabled }, set: { appSettings.hapticFeedbackEnabled = $0 })
                    
                    let soundbinding = Binding(get: { appSettings.soundEffectEnabled }, set: { appSettings.soundEffectEnabled = $0 })
                    
//                    SettingToggle(title: "Enable Haptic Feedback", isOn: hapticbinding)
                    SettingToggle(title: "Enable Sound Effects", isOn: soundbinding)
                }
                
                SettingGroup {
                    
                    SettingCustomView {
                        
                        VStack {
                            
                            HStack {
                                
                                Text("Your best score - ") +
                                Text("\(String(format: "%g", Double(appSettings.bestScore) * 0.1))%")
                                    .monospacedDigit()
                                    .fontDesign(.rounded)
                                    .foregroundStyle(colorForAccuracy(accuracy: Double(appSettings.bestScore) * 0.001))
                                Spacer()
                            }
                            
                        }
                        .padding()
                    }
                    
                    SettingButton(title: "Reset Score", indicator: "arrow.counterclockwise") {
                        showingResetWarning.toggle()
                    }
                    
                   
                    
                }
                
            }
            
        }
        
        
        .alert("Reset Score", isPresented: $showingResetWarning) {
            Button("OK", role: .destructive) {
                drawingModel.bestScore = 0
            }
            Button("Cancel", role: .cancel) {
                showingResetWarning = false
            }
        }
        
    }
}

#Preview {
    SettingsView()
        .environment(\.appSettings, AppSettings())
        .environment(\.drawingModel, DrawingModel())
}
