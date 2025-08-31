//
//  VoiceBoardApp.swift
//  VoiceBoard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import SwiftUI
import AVFoundation

@main
struct VoiceBoardApp: App {
    init() {
        // Request microphone permission on app launch
        requestMicrophonePermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    /// Requests microphone permission for the keyboard extension
    private func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Microphone permission granted")
                } else {
                    print("Microphone permission denied")
                }
            }
        }
    }
}
