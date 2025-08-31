//
//  AudioRecorderManager.swift
//  VoiceBoardKeyboard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import Foundation
import AVFoundation

/// Errors that can occur during audio recording
enum AudioRecorderError: Error, LocalizedError {
    case permissionDenied
    case recordingFailed
    case fileCreationFailed
    case audioSessionSetupFailed
    case recordingInProgress
    case noActiveRecording
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Microphone permission is required for voice recording."
        case .recordingFailed:
            return "Failed to start audio recording. Please try again."
        case .fileCreationFailed:
            return "Failed to create audio file."
        case .audioSessionSetupFailed:
            return "Failed to setup audio session."
        case .recordingInProgress:
            return "Recording is already in progress."
        case .noActiveRecording:
            return "No active recording to stop."
        }
    }
}

/**
 * AudioRecorderManager handles all audio recording functionality for the VoiceBoard keyboard.
 * It manages the AVAudioRecorder, handles permissions, and provides completion callbacks.
 */
class AudioRecorderManager: NSObject {
    
    // MARK: - Properties
    
    /// The AVAudioRecorder instance for recording audio
    private var audioRecorder: AVAudioRecorder?
    
    /// Completion handler called when recording starts
    private var recordingStartCompletion: ((Result<Void, Error>) -> Void)?
    
    /// Completion handler called when recording stops
    private var recordingStopCompletion: ((Result<URL, Error>) -> Void)?
    
    /// The URL of the current recording file
    private var currentRecordingURL: URL?
    
    /// Timer for maximum recording duration
    private var maxDurationTimer: Timer?
    
    /// Maximum recording duration in seconds
    private let maxRecordingDuration = Configuration.maxRecordingDuration
    
    /// Audio recording settings
    private let recordingSettings: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: Configuration.audioSampleRate,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    // MARK: - Public Methods
    
    /**
     * Starts audio recording with the specified completion handler.
     * - Parameter completion: Called when recording starts or fails to start
     */
    func startRecording(completion: @escaping (Result<Void, Error>) -> Void) {
        // Check if already recording
        guard audioRecorder?.isRecording != true else {
            completion(.failure(AudioRecorderError.recordingInProgress))
            return
        }
        
        recordingStartCompletion = completion
        
        // Setup audio session
        setupAudioSession { [weak self] result in
            switch result {
            case .success():
                self?.createRecordingFile { [weak self] fileResult in
                    switch fileResult {
                    case .success(let url):
                        self?.startAudioRecording(at: url)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     * Stops the current audio recording.
     * - Parameter completion: Called when recording stops with the recorded file URL or an error
     */
    func stopRecording(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let recorder = audioRecorder, recorder.isRecording else {
            completion(.failure(AudioRecorderError.noActiveRecording))
            return
        }
        
        recordingStopCompletion = completion
        
        // Cancel max duration timer
        maxDurationTimer?.invalidate()
        maxDurationTimer = nil
        
        // Stop recording
        recorder.stop()
        
        // The audioRecorderDidFinishRecording delegate method will handle the completion
    }
    
    /**
     * Checks if microphone permission is granted.
     * - Returns: True if permission is granted, false otherwise
     */
    func checkMicrophonePermission() -> Bool {
        return AVAudioSession.sharedInstance().recordPermission == .granted
    }
    
    /**
     * Gets the current recording duration.
     * - Returns: The current recording duration in seconds, or 0 if not recording
     */
    func getCurrentRecordingDuration() -> TimeInterval {
        return audioRecorder?.currentTime ?? 0
    }
    
    /**
     * Gets the average power for the current recording.
     * - Returns: The average power in decibels, or 0 if not recording
     */
    func getAveragePower() -> Float {
        guard let recorder = audioRecorder, recorder.isRecording else { return 0 }
        
        recorder.updateMeters()
        return recorder.averagePower(forChannel: 0)
    }
    
    // MARK: - Private Methods
    
    /// Sets up the audio session for recording
    private func setupAudioSession(completion: @escaping (Result<Void, Error>) -> Void) {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
            completion(.success(()))
        } catch {
            print("Failed to setup audio session: \(error)")
            completion(.failure(AudioRecorderError.audioSessionSetupFailed))
        }
    }
    
    /// Creates a temporary file for the audio recording
    private func createRecordingFile(completion: @escaping (Result<URL, Error>) -> Void) {
        let documentsPath = FileManager.default.temporaryDirectory
        let audioFileName = "voice_recording_\(Date().timeIntervalSince1970).\(Configuration.audioFormat)"
        let audioURL = documentsPath.appendingPathComponent(audioFileName)
        
        // Remove any existing file at this URL
        try? FileManager.default.removeItem(at: audioURL)
        
        currentRecordingURL = audioURL
        completion(.success(audioURL))
    }
    
    /// Starts the actual audio recording
    private func startAudioRecording(at url: URL) {
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recordingSettings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            
            if audioRecorder?.record() == true {
                // Start maximum duration timer
                startMaxDurationTimer()
                recordingStartCompletion?(.success(()))
            } else {
                recordingStartCompletion?(.failure(AudioRecorderError.recordingFailed))
            }
        } catch {
            print("Failed to create audio recorder: \(error)")
            recordingStartCompletion?(.failure(AudioRecorderError.recordingFailed))
        }
        
        recordingStartCompletion = nil
    }
    
    /// Starts the maximum duration timer to prevent excessive recording
    private func startMaxDurationTimer() {
        maxDurationTimer = Timer.scheduledTimer(withTimeInterval: maxRecordingDuration, repeats: false) { [weak self] _ in
            self?.stopRecording { result in
                // Handle automatic stop due to max duration
                switch result {
                case .success(let url):
                    print("Recording stopped automatically after \(self?.maxRecordingDuration ?? 0) seconds")
                case .failure(let error):
                    print("Error stopping recording automatically: \(error)")
                }
            }
        }
    }
    
    /// Cleans up recording resources
    private func cleanupRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        maxDurationTimer?.invalidate()
        maxDurationTimer = nil
        
        // Deactivate audio session
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
    }
}

// MARK: - AVAudioRecorderDelegate

extension AudioRecorderManager: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        defer {
            cleanupRecording()
        }
        
        if flag, let url = currentRecordingURL {
            // Check if file was created and has content
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                if let fileSize = attributes[.size] as? UInt64, fileSize > 0 {
                    recordingStopCompletion?(.success(url))
                } else {
                    recordingStopCompletion?(.failure(AudioRecorderError.fileCreationFailed))
                }
            } catch {
                recordingStopCompletion?(.failure(AudioRecorderError.fileCreationFailed))
            }
        } else {
            recordingStopCompletion?(.failure(AudioRecorderError.recordingFailed))
        }
        
        recordingStopCompletion = nil
        currentRecordingURL = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio recorder encode error: \(error?.localizedDescription ?? "Unknown error")")
        recordingStopCompletion?(.failure(error ?? AudioRecorderError.recordingFailed))
        recordingStopCompletion = nil
        cleanupRecording()
    }
}
