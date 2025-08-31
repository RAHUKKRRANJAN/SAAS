//
//  KeyboardViewController.swift
//  VoiceBoardKeyboard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import UIKit
import SwiftUI
import AVFoundation

/**
 * KeyboardViewController is the main controller for the VoiceBoard keyboard extension.
 * It hosts a SwiftUI view that provides the voice-to-text functionality.
 */
class KeyboardViewController: UIInputViewController {
    
    // MARK: - Properties
    
    /// The SwiftUI hosting controller for the keyboard interface
    private var hostingController: UIHostingController<KeyboardView>!
    
    /// Manager for audio recording functionality
    private let audioRecorderManager = AudioRecorderManager()
    
    /// Service for handling network requests to Groq API
    private let networkService = NetworkService()
    
    /// Feedback generator for haptic responses
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        setupAudioSession()
        prepareHapticFeedback()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update keyboard height
        updateKeyboardHeight()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Handle appearance changes (light/dark mode)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            hostingController.rootView.updateAppearance()
        }
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the SwiftUI keyboard interface
    private func setupKeyboard() {
        let keyboardView = KeyboardView(
            onRecordingStart: { [weak self] in
                self?.startRecording()
            },
            onRecordingEnd: { [weak self] in
                self?.stopRecording()
            },
            onDismissKeyboard: { [weak self] in
                self?.dismissKeyboard()
            },
            textDocumentProxy: textDocumentProxy
        )
        
        hostingController = UIHostingController(rootView: keyboardView)
        hostingController.view.backgroundColor = UIColor.clear
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Setup constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Configures the audio session for recording
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error.localizedDescription)")
        }
    }
    
    /// Prepares haptic feedback generators
    private func prepareHapticFeedback() {
        impactFeedback.prepare()
        lightFeedback.prepare()
    }
    
    /// Updates the keyboard height based on content
    private func updateKeyboardHeight() {
        let keyboardHeight = Configuration.keyboardHeight
        
        // Create height constraint if it doesn't exist
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: keyboardHeight)
        heightConstraint.priority = UILayoutPriority(999)
        heightConstraint.isActive = true
    }
    
    // MARK: - Recording Methods
    
    /// Starts voice recording when user presses and holds the button
    private func startRecording() {
        // Trigger medium haptic feedback
        impactFeedback.impactOccurred()
        
        // Request microphone permission if needed
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.audioRecorderManager.startRecording { [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success():
                                self?.hostingController.rootView.updateRecordingState(.recording)
                            case .failure(let error):
                                self?.handleError(error)
                            }
                        }
                    }
                } else {
                    self?.handleError(AudioRecorderError.permissionDenied)
                }
            }
        }
    }
    
    /// Stops voice recording when user releases the button
    private func stopRecording() {
        // Trigger light haptic feedback
        lightFeedback.impactOccurred()
        
        audioRecorderManager.stopRecording { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let audioURL):
                    self?.hostingController.rootView.updateRecordingState(.processing)
                    self?.transcribeAudio(from: audioURL)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    /// Transcribes audio file using Groq Whisper API
    private func transcribeAudio(from audioURL: URL) {
        networkService.transcribeAudio(audioURL: audioURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transcription):
                    self?.insertTranscribedText(transcription.text)
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    /// Inserts the transcribed text into the text field
    private func insertTranscribedText(_ text: String) {
        // Insert text at cursor position
        textDocumentProxy.insertText(text)
        
        // Update UI to show success state
        hostingController.rootView.updateRecordingState(.success)
        
        // Reset to idle state after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + Configuration.successStateDuration) { [weak self] in
            self?.hostingController.rootView.updateRecordingState(.idle)
        }
    }
    
    /// Handles various errors that can occur during recording or transcription
    private func handleError(_ error: Error) {
        print("VoiceBoard Error: \(error.localizedDescription)")
        
        // Update UI to show error state
        hostingController.rootView.updateRecordingState(.error(error.localizedDescription))
        
        // Reset to idle state after showing error
        DispatchQueue.main.asyncAfter(deadline: .now() + Configuration.errorStateDuration) { [weak self] in
            self?.hostingController.rootView.updateRecordingState(.idle)
        }
    }
    
    /// Dismisses the keyboard
    private func dismissKeyboard() {
        // In iOS, keyboard extensions don't have a direct dismiss method
        // The system handles keyboard dismissal automatically
        // This method exists for UI callback purposes
    }
}

// MARK: - UIInputViewController Overrides

extension KeyboardViewController {
    
    override func textWillChange(_ textInput: UITextInput?) {
        // Called before text changes
        super.textWillChange(textInput)
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // Called after text changes
        super.textDidChange(textInput)
    }
}
