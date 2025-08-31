//
//  WaveformView.swift
//  VoiceBoardKeyboard
//
//  Created by VoiceBoard Team
//  Copyright © 2025 VoiceBoard. All rights reserved.
//

import SwiftUI

/**
 * WaveformView provides a visual representation of audio recording levels.
 * It displays animated bars that respond to the microphone input during recording.
 */
struct WaveformView: View {
    
    // MARK: - Properties
    
    /// Array of amplitude values for each waveform bar
    let amplitudes: [CGFloat]
    
    /// Colors for the waveform bars
    private let waveformColors: [Color] = [.red, .orange, .red.opacity(0.8)]
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<amplitudes.count, id: \.self) { index in
                WaveformBar(
                    amplitude: amplitudes[index],
                    color: getBarColor(for: index)
                )
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Helper Methods
    
    /// Returns the appropriate color for a waveform bar based on its position
    private func getBarColor(for index: Int) -> Color {
        let colorIndex = index % waveformColors.count
        return waveformColors[colorIndex]
    }
}

/**
 * WaveformBar represents a single bar in the waveform visualization.
 */
struct WaveformBar: View {
    
    // MARK: - Properties
    
    /// The amplitude (height) of this bar
    let amplitude: CGFloat
    
    /// The color of this bar
    let color: Color
    
    /// Maximum height for the waveform bar
    private let maxHeight: CGFloat = 40
    
    /// Minimum height for the waveform bar
    private let minHeight: CGFloat = 4
    
    /// Width of each waveform bar
    private let barWidth: CGFloat = 3
    
    // MARK: - Body
    
    var body: some View {
        RoundedRectangle(cornerRadius: barWidth / 2)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [color, color.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(
                width: barWidth,
                height: max(minHeight, amplitude * maxHeight)
            )
            .animation(.easeInOut(duration: 0.1), value: amplitude)
    }
}

// MARK: - Preview

struct WaveformView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // Static waveform
            WaveformView(amplitudes: Array(repeating: 0.5, count: 30))
                .background(Color.black.opacity(0.1))
            
            // Animated waveform with varying amplitudes
            WaveformView(amplitudes: (0..<40).map { _ in CGFloat.random(in: 0.2...1.0) })
                .background(Color.black.opacity(0.1))
            
            // Low amplitude waveform
            WaveformView(amplitudes: (0..<25).map { _ in CGFloat.random(in: 0.1...0.3) })
                .background(Color.black.opacity(0.1))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
