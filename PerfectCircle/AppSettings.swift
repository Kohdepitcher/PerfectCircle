//
//  AppSettings.swift
//  PerfectCircle
//
//  Created by Kohde Pitcher on 29/10/2023.
//

import Foundation
import Observation
import SwiftUI

@Observable
class AppSettings: ObservableObject {
    
    //MARK: - User Default Strings
    /// This outlines all the strings that are used with user defaults to store and retrieve settings
    public enum AppSettingKeys: String {
        
        /// Tracks if the app should use haptic feedback for UI feedback
        case hapticFeedbackEnabled
        
        /// Tracks if sound effects should be played in the app
        case soundEffectEnabled
        
        case bestScore

        
    }
    
    /// For tracking if haptics should be used
    var hapticFeedbackEnabled: Bool {
        
        didSet {
            UserDefaults.standard.set(hapticFeedbackEnabled, forKey: AppSettingKeys.hapticFeedbackEnabled.rawValue)
        }
        
    }
    
    /// For tracking if sound effects should be used
    var soundEffectEnabled: Bool {
        
        didSet {
            UserDefaults.standard.set(soundEffectEnabled, forKey: AppSettingKeys.soundEffectEnabled.rawValue)
        }
        
    }
    
    var bestScore: Int {
        
        didSet {
            UserDefaults.standard.set(bestScore, forKey: AppSettingKeys.bestScore.rawValue)
        }
        
    }
    
    /// Initialiser
    /// Sets each of the properties with the value from user defaults otherwise a default value is provided
    init() {
        
        self.hapticFeedbackEnabled = UserDefaults.standard.object(forKey: AppSettingKeys.hapticFeedbackEnabled.rawValue) as? Bool ?? true
        self.soundEffectEnabled = UserDefaults.standard.object(forKey: AppSettingKeys.soundEffectEnabled.rawValue) as? Bool ?? true
        self.bestScore = UserDefaults.standard.object(forKey: AppSettingKeys.bestScore.rawValue) as? Int ?? 0
    }
    
    /// When called, returns app settings back to defaults
    public func resetToDefaults() {
        
        self.hapticFeedbackEnabled = true
        self.soundEffectEnabled = true
        self.bestScore = 0
        
    }
    
}

extension EnvironmentValues {
    var appSettings: AppSettings {
        get { self[AppSettingsKey.self] }
        set { self[AppSettingsKey.self] = newValue }
    }
}

private struct AppSettingsKey: EnvironmentKey {
    static var defaultValue: AppSettings = AppSettings()
}
