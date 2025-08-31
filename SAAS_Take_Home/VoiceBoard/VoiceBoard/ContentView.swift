//
//  ContentView.swift
//  VoiceBoard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // App Icon and Title
                VStack(spacing: 16) {
                    Image(systemName: "keyboard.badge.waveform")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue.gradient)
                    
                    Text("VoiceBoard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("AI-Powered Voice-to-Text Keyboard")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Setup Instructions
                VStack(alignment: .leading, spacing: 20) {
                    Text("Setup Instructions")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        InstructionRow(
                            number: "1",
                            title: "Enable the Keyboard",
                            description: "Go to Settings → General → Keyboard → Keyboards"
                        )
                        
                        InstructionRow(
                            number: "2",
                            title: "Add VoiceBoard",
                            description: "Tap 'Add New Keyboard...' and select VoiceBoard"
                        )
                        
                        InstructionRow(
                            number: "3",
                            title: "Allow Full Access",
                            description: "Enable 'Allow Full Access' for voice transcription"
                        )
                        
                        InstructionRow(
                            number: "4",
                            title: "Start Typing",
                            description: "Tap the globe icon to switch to VoiceBoard"
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Settings Button
                Button(action: {
                    openKeyboardSettings()
                }) {
                    HStack {
                        Image(systemName: "gear")
                        Text("Open Keyboard Settings")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.gradient)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .navigationBarHidden(true)
        }
    }
    
    /// Opens the iOS Keyboard Settings directly
    private func openKeyboardSettings() {
        if let url = URL(string: "App-Prefs:root=General&path=Keyboard") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                // Fallback to general settings
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }
    }
}

struct InstructionRow: View {
    let number: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Number Circle
            Text(number)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(Color.blue.gradient)
                .clipShape(Circle())
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        
        ContentView()
            .preferredColorScheme(.dark)
    }
}
