//
//  Configuration.swift
//  VoiceBoardKeyboard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import Foundation

/**
 * Configuration manager for the VoiceBoard keyboard extension.
 * Handles secure storage and retrieval of API keys and other settings.
 */
struct Configuration {
    
    // MARK: - API Configuration
    
    /// Groq API base URL
    static let groqAPIBaseURL = "https://api.groq.com/openai/v1"
    
    /// Whisper model to use for transcription
    static let whisperModel = "whisper-large-v3"
    
    /// Default language for transcription (auto-detect if nil)
    static let defaultLanguage: String? = "en"
    
    // MARK: - Audio Configuration
    
    /// Maximum recording duration in seconds
    static let maxRecordingDuration: TimeInterval = 60.0
    
    /// Audio sample rate
    static let audioSampleRate: Double = 44100.0
    
    /// Audio format
    static let audioFormat = "m4a"
    
    // MARK: - Network Configuration
    
    /// Network request timeout in seconds
    static let networkTimeout: TimeInterval = 30.0
    
    /// Maximum number of retry attempts
    static let maxRetryAttempts = 3
    
    // MARK: - UI Configuration
    
    /// Keyboard height
    static let keyboardHeight: CGFloat = 280
    
    /// Button animation duration
    static let buttonAnimationDuration: Double = 0.3
    
    /// Success state display duration
    static let successStateDuration: TimeInterval = 1.5
    
    /// Error state display duration
    static let errorStateDuration: TimeInterval = 3.0
    
    // MARK: - API Key Management
    
    /// Retrieves the Groq API key from various sources
    static func getGroqAPIKey() -> String? {
        // Method 1: Info.plist
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["GROQ_API_KEY"] as? String,
           !apiKey.isEmpty && apiKey != "your_groq_api_key_here" {
            return apiKey
        }
        
        // Method 2: Environment variable
        if let apiKey = ProcessInfo.processInfo.environment["GROQ_API_KEY"], 
           !apiKey.isEmpty {
            return apiKey
        }
        
        // Method 3: UserDefaults
        if let apiKey = UserDefaults.standard.string(forKey: "GroqAPIKey"), 
           !apiKey.isEmpty {
            return apiKey
        }
        
        return nil
    }
    
    /// Sets the API key in UserDefaults
    static func setGroqAPIKey(_ key: String) {
        UserDefaults.standard.set(key, forKey: "GroqAPIKey")
    }
    
    /// Validates that an API key is properly configured
    static func validateAPIKey() -> Bool {
        guard let apiKey = getGroqAPIKey(),
              !apiKey.isEmpty,
              apiKey != "your_groq_api_key_here" else {
            return false
        }
        return true
    }
}
