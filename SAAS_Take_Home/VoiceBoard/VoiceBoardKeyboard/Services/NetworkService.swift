//
//  NetworkService.swift
//  VoiceBoardKeyboard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import Foundation

/// Errors that can occur during network operations
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case apiKeyMissing
    case transcriptionFailed(String)
    case networkUnavailable
    case timeout
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .noData:
            return "No data received from server"
        case .invalidResponse:
            return "Invalid response format"
        case .apiKeyMissing:
            return "API key is missing. Please configure your Groq API key."
        case .transcriptionFailed(let message):
            return "Transcription failed: \(message)"
        case .networkUnavailable:
            return "Network is unavailable. Please check your connection."
        case .timeout:
            return "Request timed out. Please try again."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        }
    }
}

/**
 * NetworkService handles all network communication with the Groq Whisper API.
 * It manages API requests, error handling, and response parsing.
 */
class NetworkService {
    
    // MARK: - Properties
    
    /// The base URL for Groq API
    private let baseURL = Configuration.groqAPIBaseURL
    
    /// The API endpoint for audio transcription
    private let transcriptionEndpoint = "/audio/transcriptions"
    
    /// URLSession for network requests
    private let urlSession: URLSession
    
    /// Request timeout interval
    private let timeoutInterval = Configuration.networkTimeout
    
    /// API key for Groq service
    private var apiKey: String? {
        return Configuration.getGroqAPIKey()
    }
    
    // MARK: - Initialization
    
    init() {
        // Configure URLSession with timeout
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval * 2
        
        self.urlSession = URLSession(configuration: configuration)
    }
    
    // MARK: - Public Methods
    
    /**
     * Transcribes audio file using Groq's Whisper API.
     * - Parameters:
     *   - audioURL: The URL of the audio file to transcribe
     *   - completion: Completion handler with the transcription result
     */
    func transcribeAudio(audioURL: URL, completion: @escaping (Result<TranscriptionResponse, Error>) -> Void) {
        // Validate API key
        guard let apiKey = apiKey, !apiKey.isEmpty, apiKey != "your_groq_api_key_here" else {
            completion(.failure(NetworkError.apiKeyMissing))
            return
        }
        
        // Create the request
        guard let request = createTranscriptionRequest(audioURL: audioURL, apiKey: apiKey) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform the network request
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            self?.handleTranscriptionResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    // MARK: - Private Methods
    
    /// Creates a multipart/form-data request for audio transcription
    private func createTranscriptionRequest(audioURL: URL, apiKey: String) -> URLRequest? {
        guard let url = URL(string: baseURL + transcriptionEndpoint) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // Create multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create the body
        guard let bodyData = createMultipartBody(audioURL: audioURL, boundary: boundary) else {
            return nil
        }
        
        request.httpBody = bodyData
        return request
    }
    
    /// Creates multipart form data body for the API request
    private func createMultipartBody(audioURL: URL, boundary: String) -> Data? {
        var bodyData = Data()
        
        // Read audio file data
        guard let audioData = try? Data(contentsOf: audioURL) else {
            print("Failed to read audio file at: \(audioURL)")
            return nil
        }
        
        // Add file parameter
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        bodyData.append(audioData)
        bodyData.append("\r\n".data(using: .utf8)!)
        
        // Add model parameter
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append(Configuration.whisperModel.data(using: .utf8)!)
        bodyData.append("\r\n".data(using: .utf8)!)
        
        // Add language parameter (optional - let Whisper auto-detect)
        if let language = Configuration.defaultLanguage {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
            bodyData.append(language.data(using: .utf8)!)
            bodyData.append("\r\n".data(using: .utf8)!)
        }
        
        // Add response format parameter
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"response_format\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("json".data(using: .utf8)!)
        bodyData.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return bodyData
    }
    
    /// Handles the response from the transcription API
    private func handleTranscriptionResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<TranscriptionResponse, Error>) -> Void
    ) {
        // Handle network errors
        if let error = error {
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    completion(.failure(NetworkError.networkUnavailable))
                case .timedOut:
                    completion(.failure(NetworkError.timeout))
                default:
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error))
            }
            return
        }
        
        // Handle HTTP errors
        if let httpResponse = response as? HTTPURLResponse {
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
                return
            }
        }
        
        // Handle missing data
        guard let data = data else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        // Parse JSON response
        do {
            let transcriptionResponse = try JSONDecoder().decode(TranscriptionResponse.self, from: data)
            
            // Validate that we received text
            if transcriptionResponse.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                completion(.failure(NetworkError.transcriptionFailed("No speech detected in audio")))
            } else {
                completion(.success(transcriptionResponse))
            }
        } catch {
            print("Failed to decode transcription response: \(error)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert to string")")
            completion(.failure(NetworkError.invalidResponse))
        }
    }
}
}
