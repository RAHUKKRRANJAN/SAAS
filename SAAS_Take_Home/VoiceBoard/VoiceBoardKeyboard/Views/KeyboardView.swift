//
//  KeyboardView.swift
//  VoiceBoardKeyboard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import SwiftUI
import UIKit

/// Represents the current state of the voice recording functionality
enum RecordingState: Equatable {
    case idle
    case recording
    case processing
    case success
    case error(String)
}

/**
 * KeyboardView is the main SwiftUI interface for the VoiceBoard keyboard.
 * It provides a clean, modern interface with a single button for voice recording.
 */
struct KeyboardView: View {
    
    // MARK: - Properties
    
    /// Current state of the recording functionality
    @State private var recordingState: RecordingState = .idle
    
    /// Closure called when recording starts
    let onRecordingStart: () -> Void
    
    /// Closure called when recording ends
    let onRecordingEnd: () -> Void
    
    /// Closure called when keyboard should be dismissed
    let onDismissKeyboard: () -> Void
    
    /// Text document proxy for inserting text
    let textDocumentProxy: UITextDocumentProxy
    
    /// Animation scale for the recording button
    @State private var buttonScale: CGFloat = 1.0
    
    /// Animation opacity for the pulsing effect
    @State private var pulseOpacity: Double = 1.0
    
    /// Waveform amplitudes for visualization
    @State private var waveformAmplitudes: [CGFloat] = Array(repeating: 0.1, count: 40)
    
    /// Timer for waveform animation
    @State private var waveformTimer: Timer?
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top toolbar with keyboard controls
                topToolbar
                    .frame(height: 44)
                    .background(keyboardBackgroundColor)
                
                // Main content area
                mainContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(keyboardBackgroundColor)
            }
        }
        .background(keyboardBackgroundColor)
        .onAppear {
            updateAppearance()
        }
    }
    
    // MARK: - View Components
    
    /// Top toolbar with keyboard utility buttons
    private var topToolbar: some View {
        HStack {
            // Dismiss keyboard button
            Button(action: {
                onDismissKeyboard()
            }) {
                Image(systemName: "keyboard.chevron.compact.down")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // App branding
            Text("VoiceBoard")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Delete button
            Button(action: {
                textDocumentProxy.deleteBackward()
            }) {
                Image(systemName: "delete.left")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
    }
    
    /// Main content area with the voice recording button
    private var mainContent: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Status indicator
            statusIndicator
            
            // Waveform visualization (shown during recording)
            if recordingState == .recording {
                WaveformView(amplitudes: waveformAmplitudes)
                    .frame(height: 60)
                    .padding(.horizontal, 40)
                    .transition(.opacity.combined(with: .scale))
            }
            
            // Main voice recording button
            voiceRecordingButton
                .scaleEffect(buttonScale)
                .opacity(pulseOpacity)
            
            Spacer()
        }
    }
    
    /// Status indicator showing current state
    private var statusIndicator: some View {
        HStack(spacing: 8) {
            statusIcon
            statusText
        }
        .padding(.horizontal, 20)
        .frame(minHeight: 30)
    }
    
    /// Icon for the current status
    private var statusIcon: some View {
        Group {
            switch recordingState {
            case .idle:
                Image(systemName: "waveform")
                    .foregroundColor(.blue)
            case .recording:
                Image(systemName: "mic.fill")
                    .foregroundColor(.red)
            case .processing:
                ProgressView()
                    .scaleEffect(0.8)
            case .success:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            case .error:
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
            }
        }
        .font(.title3)
    }
    
    /// Text for the current status
    private var statusText: some View {
        Group {
            switch recordingState {
            case .idle:
                Text("Hold to record voice")
            case .recording:
                Text("Recording... Release to transcribe")
            case .processing:
                Text("Transcribing...")
            case .success:
                Text("Text inserted!")
            case .error(let message):
                Text(message)
                    .foregroundColor(.red)
            }
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    
    /// Main voice recording button
    private var voiceRecordingButton: some View {
        Button(action: {}) {
            ZStack {
                // Background circle
                Circle()
                    .fill(buttonBackgroundGradient)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(buttonBorderColor, lineWidth: recordingState == .recording ? 4 : 2)
                    )
                
                // Icon
                buttonIcon
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(VoiceButtonStyle())
        .disabled(recordingState == .processing)
        .onLongPressGesture(
            minimumDuration: 0.1,
            maximumDistance: 50,
            pressing: { pressing in
                handleButtonPress(pressing)
            },
            perform: {}
        )
    }
    
    /// Icon for the recording button based on current state
    private var buttonIcon: some View {
        Group {
            switch recordingState {
            case .idle:
                Image(systemName: "mic")
            case .recording:
                Image(systemName: "mic.fill")
            case .processing:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            case .success:
                Image(systemName: "checkmark")
            case .error:
                Image(systemName: "xmark")
            }
        }
    }
    
    // MARK: - Computed Properties
    
    /// Background color for the keyboard
    private var keyboardBackgroundColor: Color {
        Color(UIColor.systemBackground)
    }
    
    /// Gradient for the recording button background
    private var buttonBackgroundGradient: LinearGradient {
        switch recordingState {
        case .idle:
            return LinearGradient(
                gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .recording:
            return LinearGradient(
                gradient: Gradient(colors: [.red, .red.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .processing:
            return LinearGradient(
                gradient: Gradient(colors: [.orange, .orange.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .success:
            return LinearGradient(
                gradient: Gradient(colors: [.green, .green.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .error:
            return LinearGradient(
                gradient: Gradient(colors: [.red, .red.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    /// Border color for the recording button
    private var buttonBorderColor: Color {
        recordingState == .recording ? .red.opacity(0.8) : .clear
    }
    
    // MARK: - Methods
    
    /// Handles button press and release events
    private func handleButtonPress(_ pressing: Bool) {
        if pressing {
            startButtonPress()
        } else {
            endButtonPress()
        }
    }
    
    /// Handles the start of button press (recording start)
    private func startButtonPress() {
        guard recordingState == .idle else { return }
        
        // Start recording
        onRecordingStart()
        
        // Start animations
        withAnimation(.easeInOut(duration: 0.1)) {
            buttonScale = 1.1
        }
        
        startPulseAnimation()
        startWaveformAnimation()
    }
    
    /// Handles the end of button press (recording stop)
    private func endButtonPress() {
        guard recordingState == .recording else { return }
        
        // Stop recording
        onRecordingEnd()
        
        // Stop animations
        withAnimation(.easeInOut(duration: 0.2)) {
            buttonScale = 1.0
        }
        
        stopAnimations()
    }
    
    /// Starts the pulsing animation for the recording button
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            pulseOpacity = 0.7
        }
    }
    
    /// Starts the waveform animation during recording
    private func startWaveformAnimation() {
        waveformTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                for i in 0..<waveformAmplitudes.count {
                    waveformAmplitudes[i] = CGFloat.random(in: 0.1...1.0)
                }
            }
        }
    }
    
    /// Stops all animations
    private func stopAnimations() {
        waveformTimer?.invalidate()
        waveformTimer = nil
        
        withAnimation(.easeInOut(duration: 0.3)) {
            pulseOpacity = 1.0
            waveformAmplitudes = Array(repeating: 0.1, count: 40)
        }
    }
    
    /// Updates the recording state
    func updateRecordingState(_ newState: RecordingState) {
        withAnimation(.easeInOut(duration: 0.3)) {
            recordingState = newState
        }
        
        // Stop animations if not recording
        if newState != .recording {
            stopAnimations()
        }
    }
    
    /// Updates the appearance for dark/light mode changes
    func updateAppearance() {
        // This method can be called to refresh the UI when appearance changes
    }
}

// MARK: - Custom Button Style

/// Custom button style for the voice recording button
struct VoiceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardView(
            onRecordingStart: {},
            onRecordingEnd: {},
            onDismissKeyboard: {},
            textDocumentProxy: MockTextDocumentProxy()
        )
        .frame(height: 280)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.light)
        
        KeyboardView(
            onRecordingStart: {},
            onRecordingEnd: {},
            onDismissKeyboard: {},
            textDocumentProxy: MockTextDocumentProxy()
        )
        .frame(height: 280)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Mock Text Document Proxy

/// Mock implementation of UITextDocumentProxy for previews
class MockTextDocumentProxy: NSObject, UITextDocumentProxy {
    var documentContextBeforeInput: String? = ""
    var documentContextAfterInput: String? = ""
    var selectedText: String? = ""
    var documentInputMode: UITextInputMode? = nil
    var documentIdentifier: UUID = UUID()
    
    func adjustTextPosition(byCharacterOffset offset: Int) {}
    func setMarkedText(_ markedText: String, selectedRange: NSRange) {}
    func unmarkText() {}
    func insertText(_ text: String) {
        print("Inserting text: \(text)")
    }
    func deleteBackward() {
        print("Deleting backward")
    }
}
