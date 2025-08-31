//
//  TranscriptionModels.swift
//  VoiceBoardKeyboard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import Foundation

/**
 * Response model for the Groq Whisper API transcription endpoint.
 * This matches the expected JSON structure from the API.
 */
struct TranscriptionResponse: Codable {
    /// The transcribed text from the audio
    let text: String
    
    /// Optional task type (usually "transcribe")
    let task: String?
    
    /// Optional language detected in the audio
    let language: String?
    
    /// Optional duration of the audio in seconds
    let duration: Double?
    
    /// Optional segments with detailed timing information
    let segments: [TranscriptionSegment]?
    
    init(text: String, task: String? = nil, language: String? = nil, duration: Double? = nil, segments: [TranscriptionSegment]? = nil) {
        self.text = text
        self.task = task
        self.language = language
        self.duration = duration
        self.segments = segments
    }
}

/**
 * Represents a segment of the transcription with timing information.
 * This provides more detailed information about when specific words were spoken.
 */
struct TranscriptionSegment: Codable {
    /// Unique identifier for this segment
    let id: Int
    
    /// The start time of this segment in seconds
    let start: Double
    
    /// The end time of this segment in seconds
    let end: Double
    
    /// The transcribed text for this segment
    let text: String
    
    /// Array of tokens (words) in this segment
    let tokens: [Int]?
    
    /// Temperature used for this segment's transcription
    let temperature: Double?
    
    /// Average log probability of the tokens in this segment
    let avgLogprob: Double?
    
    /// Compression ratio for this segment
    let compressionRatio: Double?
    
    /// Probability that this segment contains no speech
    let noSpeechProb: Double?
    
    /// Array of individual words with timing information
    let words: [TranscriptionWord]?
}

/**
 * Represents an individual word in the transcription with precise timing.
 */
struct TranscriptionWord: Codable {
    /// The word text
    let word: String
    
    /// The start time of this word in seconds
    let start: Double
    
    /// The end time of this word in seconds
    let end: Double
    
    /// Confidence probability for this word
    let probability: Double?
}

/**
 * Error response model from the Groq API.
 * This handles error cases when the API returns an error instead of a successful transcription.
 */
struct TranscriptionErrorResponse: Codable {
    /// Error information
    let error: TranscriptionError
}

/**
 * Detailed error information from the API.
 */
struct TranscriptionError: Codable {
    /// Error message from the API
    let message: String
    
    /// Error type or code
    let type: String?
    
    /// Error code (if provided)
    let code: String?
}

// MARK: - Helper Extensions

extension TranscriptionResponse {
    /// Returns true if the transcription contains meaningful text
    var hasValidText: Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Returns the text with cleaned whitespace
    var cleanedText: String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Returns the detected language or "unknown" if not specified
    var detectedLanguage: String {
        return language ?? "unknown"
    }
    
    /// Returns a formatted duration string (e.g., "2.5s")
    var formattedDuration: String? {
        guard let duration = duration else { return nil }
        return String(format: "%.1fs", duration)
    }
}

extension TranscriptionSegment {
    /// Returns the duration of this segment
    var duration: Double {
        return end - start
    }
    
    /// Returns a formatted time range string (e.g., "1.2s - 3.4s")
    var timeRange: String {
        return String(format: "%.1fs - %.1fs", start, end)
    }
}

extension TranscriptionWord {
    /// Returns the duration of this word
    var duration: Double {
        return end - start
    }
    
    /// Returns true if this word has high confidence (> 0.8)
    var isHighConfidence: Bool {
        return (probability ?? 0) > 0.8
    }
}

// MARK: - Sample Data for Testing

#if DEBUG
extension TranscriptionResponse {
    /// Sample transcription response for testing and previews
    static let sampleResponse = TranscriptionResponse(
        text: "Hello, this is a sample transcription from the VoiceBoard keyboard.",
        task: "transcribe",
        language: "en",
        duration: 3.5,
        segments: [
            TranscriptionSegment(
                id: 0,
                start: 0.0,
                end: 3.5,
                text: "Hello, this is a sample transcription from the VoiceBoard keyboard.",
                tokens: [15496, 11, 428, 318, 257, 6291, 35288, 422, 262, 15902, 12498, 10586, 13],
                temperature: 0.0,
                avgLogprob: -0.15,
                compressionRatio: 1.2,
                noSpeechProb: 0.01,
                words: [
                    TranscriptionWord(word: "Hello", start: 0.0, end: 0.5, probability: 0.99),
                    TranscriptionWord(word: "this", start: 0.8, end: 1.0, probability: 0.95),
                    TranscriptionWord(word: "is", start: 1.0, end: 1.1, probability: 0.98)
                ]
            )
        ]
    )
}
#endif
