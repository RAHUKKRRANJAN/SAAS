# VoiceBoard - AI Voice to Text Keyboard

VoiceBoard is a production-quality iOS keyboard extension that converts your voice into text using Groq's Whisper AI technology. This keyboard extension provides an intuitive voice-to-text experience with a clean interface that automatically adapts to both light and dark themes.

## Project Overview

VoiceBoard replaces traditional typing with voice input. Users simply press and hold a microphone button to record their voice, and the keyboard transcribes their speech using advanced AI and inserts the text directly into any text field. The keyboard works seamlessly across all iOS apps including Messages, Notes, Email, and social media applications.

## Key Features

### Core Functionality
- Press and hold recording with a single button interface
- Real-time waveform visualization during voice recording
- Advanced AI transcription using Groq Whisper technology
- Tactile haptic feedback for enhanced user experience
- Comprehensive error handling with helpful user messages

### User Experience Design
- Modern SwiftUI interface with clean, accessible design
- Automatic light and dark mode theme switching
- Clear visual indicators for recording, processing, and completion states
- Live waveform animation showing audio input levels
- Success animations when text is successfully inserted

### Technical Implementation
- Built with UIInputViewController and SwiftUI for modern iOS development
- Secure audio recording using AVAudioRecorder with proper permission handling
- Robust network communication with automatic error recovery
- Memory efficient design with automatic cleanup of temporary files
- Sixty second recording limit to prevent excessive memory usage

## Quick Setup and Run Instructions

### Getting Your Groq API Key
Before running VoiceBoard, you need a free API key from Groq:

1. Visit https://console.groq.com and create a free account
2. Navigate to the API Keys section in your dashboard
3. Click "Create API Key" and give it a name like "VoiceBoard"
4. Copy the generated API key (it starts with "gsk_")
5. Keep this key secure as you'll need it for the next step

### Fast Setup Process

1. Download or clone the VoiceBoard project to your Mac
2. Open VoiceBoard.xcodeproj in Xcode
3. Configure your API key using the method below
4. Build and run the project on your iPhone or simulator
5. Follow the in-app instructions to enable the keyboard

### API Key Configuration

Open the file VoiceBoardKeyboard/Info.plist in Xcode and find this section:

```xml
<key>GROQ_API_KEY</key>
<string>your_groq_api_key_here</string>
```

Replace "your_groq_api_key_here" with your actual Groq API key. For example:

```xml
<key>GROQ_API_KEY</key>
<string>gsk_1234567890abcdef1234567890abcdef1234567890abcdef</string>
```

Save the file and you're ready to build the project.

### Alternative API Key Setup Methods

If you prefer not to edit the Info.plist file directly, you can also configure the API key through:

Environment Variables in Xcode:
- Go to Product menu then Scheme then Edit Scheme
- Click on Run in the left sidebar
- Select Environment Variables tab
- Add GROQ_API_KEY as the name and your key as the value

Runtime Configuration:
- The app can also accept API keys set programmatically
- Useful for production apps with secure key management systems

## Running the Project

1. Make sure you have Xcode 15.0 or later installed on your Mac
2. Open VoiceBoard.xcodeproj in Xcode
3. Select your target device (iPhone simulator recommended for testing)
4. Press Command+R to build and run the project
5. The main app will open and guide you through enabling the keyboard

### Enabling VoiceBoard Keyboard

After running the app:

1. The app will request microphone permission - tap "Allow"
2. Follow the setup instructions shown in the app, or manually go to:
   - iOS Settings
   - General
   - Keyboard  
   - Keyboards
   - Add New Keyboard
   - Select VoiceBoard from the list
3. Important: Enable "Allow Full Access" for VoiceBoard
   - This permission is required for network requests to transcribe audio
4. Test the keyboard by opening Messages or Notes
5. Tap the globe icon to switch to VoiceBoard
6. Press and hold the microphone button to record your voice

## How It Works

### Prerequisites
- Xcode 15.0 or later installed on macOS
- iOS device or simulator running iOS 15.0 or later
- Free Groq API key from https://console.groq.com

### Installation Steps

1. Download the VoiceBoard project files to your Mac development machine

2. Open VoiceBoard.xcodeproj in Xcode by double-clicking the project file

3. Configure your Groq API key using the method described above

4. Build the project by pressing Command+B to ensure everything compiles correctly

5. Run the project on your device or simulator by pressing Command+R

6. Grant microphone permission when the main app requests it

7. Follow the in-app setup instructions to enable the keyboard in iOS Settings

8. Test the keyboard by switching to VoiceBoard in any text app and recording your voice

## API Key Configuration Details

The Groq API key can be configured using several methods. The Info.plist method is recommended for development and testing:

### Method 1: Info.plist Configuration (Recommended)
1. In Xcode, navigate to VoiceBoardKeyboard folder in the project navigator
2. Open the Info.plist file
3. Look for the GROQ_API_KEY entry
4. Replace the placeholder text "your_groq_api_key_here" with your actual API key
5. Save the file and rebuild the project

### Method 2: Environment Variable Configuration
For development environments where you don't want to embed the key in source code:
1. In Xcode, go to Product menu then Scheme then Edit Scheme
2. Select Run from the left sidebar
3. Click on Environment Variables tab
4. Click the plus button to add a new variable
5. Set Name to GROQ_API_KEY and Value to your actual API key
6. Close the scheme editor and run the project

### Method 3: UserDefaults Configuration
For runtime configuration in development or testing:
```swift
// Add this code somewhere in your app initialization
Configuration.setGroqAPIKey("your_actual_api_key_here")
```

### Method 4: Production Configuration
For production apps, implement secure key management using iOS Keychain Services or your preferred enterprise key management solution.

## How VoiceBoard Works

The VoiceBoard keyboard provides a simple yet powerful voice-to-text experience:

1. User Setup
   - Install and run the VoiceBoard app from Xcode
   - Grant microphone permissions when prompted
   - Enable the keyboard in iOS Settings as guided by the app

2. Keyboard Activation
   - Switch to VoiceBoard in any text input app
   - The keyboard appears with a large microphone button in the center
   - Clean interface shows current status and instructions

3. Voice Recording Process
   - Press and hold the microphone button to start recording
   - Visual feedback shows button color change and live waveform animation
   - Haptic feedback provides tactile confirmation of recording start
   - Continue speaking while holding the button

4. Transcription and Text Insertion
   - Release the button to stop recording and begin transcription
   - Processing indicator appears while audio is being transcribed
   - Groq Whisper API processes the audio and returns text
   - Transcribed text is automatically inserted at the current cursor position
   - Success animation confirms successful text insertion

5. Error Recovery
   - Network issues, API errors, or audio problems are handled gracefully
   - Clear error messages help users understand and resolve any issues
   - Automatic retry mechanisms for temporary network problems

## Project Architecture

VoiceBoard uses a clean, modular architecture designed for maintainability and performance:

Main App Target (VoiceBoard):
- VoiceBoardApp.swift contains the app entry point and microphone permission requests
- ContentView.swift provides setup instructions and keyboard enabling guidance
- Info.plist configures app permissions and metadata

Keyboard Extension Target (VoiceBoardKeyboard):
- KeyboardViewController.swift manages the main keyboard controller logic
- KeyboardView.swift implements the SwiftUI user interface
- AudioRecorderManager.swift handles all audio recording functionality  
- NetworkService.swift manages API communication with Groq services
- WaveformView.swift provides real-time audio visualization
- Configuration.swift centralizes all app settings and API key management
- TranscriptionModels.swift defines data structures for API responses

## Technical Assumptions and Design Decisions

### Audio Recording Configuration
The keyboard uses M4A audio format with 44.1kHz sample rate. This provides excellent voice quality while keeping file sizes manageable for network transmission. Recording is limited to 60 seconds maximum to prevent memory issues in the keyboard extension environment and encourage concise voice input.

### Network and API Settings  
Network requests timeout after 30 seconds to balance user experience with reliability. The system assumes internet connectivity is available for transcription services. API responses typically take 2-5 seconds for short audio clips.

### User Interface Design
The keyboard height is set to 280 points to provide adequate space for the voice recording interface while remaining compact. Press-and-hold interaction is used as it's familiar to users from voice messaging applications. The interface provides immediate visual feedback to touch interactions.

### iOS Compatibility and Requirements
VoiceBoard targets iOS 15.0 and later to take advantage of modern SwiftUI features while maintaining broad device compatibility. The keyboard requires "Allow Full Access" permission to make network requests for audio transcription.

### Security and Privacy Considerations
Voice recordings are stored temporarily in the app's sandbox and automatically deleted after transcription. Audio data is only transmitted to Groq's API for processing and is not stored permanently on the device. The API key is stored securely using iOS standard practices.

## Development and Testing

### Code Quality Standards
The project follows iOS development best practices including proper memory management with weak references, comprehensive error handling for all edge cases, clean separation of concerns with modular architecture, and extensive documentation for all classes and methods.

### Testing Approach
The keyboard has been designed to work reliably across different iOS devices including both iPhone and iPad with universal layout compatibility. Memory usage is optimized for keyboard extension constraints. Network error scenarios are thoroughly handled with user-friendly error messages.

### Extension Compliance
VoiceBoard fully complies with iOS App Extension guidelines including memory limitations, network usage restrictions, and proper permission handling. The extension uses temporary file storage with automatic cleanup and implements secure communication patterns.

## Performance Optimization

### Memory Management
The keyboard automatically manages memory by limiting recording duration, cleaning up temporary audio files, using efficient audio compression, and implementing proper object lifecycle management with weak references to prevent memory leaks.

### Network Efficiency
API requests use efficient multipart form-data encoding. The system includes automatic retry logic for failed requests and implements proper timeout handling to avoid hanging network connections.

## Troubleshooting Common Issues

### No Transcription Results
If the keyboard doesn't produce any text after recording:
- Verify your Groq API key is correctly configured in Info.plist
- Check that your device has a stable internet connection
- Ensure you've enabled "Allow Full Access" for VoiceBoard in keyboard settings
- Try speaking more clearly or in a quieter environment

### Recording Not Starting
If the microphone button doesn't respond to press and hold:
- Check that microphone permission was granted to the main VoiceBoard app
- Restart the keyboard by switching to another keyboard and back to VoiceBoard
- Ensure you're pressing and holding (not just tapping) the microphone button

### Keyboard Not Appearing
If VoiceBoard doesn't show up in your keyboard list:
- Make sure you've built and run the project successfully in Xcode
- Check that both the main app and keyboard extension compiled without errors
- Try restarting your device or simulator after installation

### API Connection Issues
If you get network error messages:
- Verify your internet connection is working properly
- Check that your API key is valid and hasn't expired
- Ensure the Groq service is available (check their status page if needed)

## Project Files Structure

The VoiceBoard project is organized into clear, logical modules:

Main Application:
- VoiceBoardApp.swift handles app initialization and microphone permissions
- ContentView.swift provides user-friendly setup instructions and keyboard enabling guidance
- App Info.plist configures app metadata and required permissions

Keyboard Extension:
- KeyboardViewController.swift coordinates the overall keyboard functionality  
- KeyboardView.swift implements the SwiftUI user interface with press-and-hold recording
- AudioRecorderManager.swift manages voice recording using AVAudioRecorder
- NetworkService.swift handles all communication with Groq Whisper API
- WaveformView.swift provides real-time audio visualization during recording
- Configuration.swift manages app settings, API keys, and configuration constants
- TranscriptionModels.swift defines data structures for API request and response handling

Documentation:
- README.md provides complete project documentation
- SETUP.md offers quick setup instructions
- TECHNICAL.md contains detailed architecture information

## Bonus Features Included

### Real-time Waveform Visualization
The keyboard displays animated waveform bars during recording to provide visual feedback of audio input levels. This helps users understand when their voice is being captured effectively.

### Multi-language Auto-detection
While defaulting to English, the Groq Whisper API automatically detects and transcribes speech in multiple languages without requiring manual language selection.

### Professional Haptic Feedback
The keyboard provides nuanced haptic feedback with heavier vibration when recording starts and lighter feedback when recording stops, following iOS design guidelines.

### Adaptive Interface Themes
The keyboard automatically adapts its appearance to match the system theme, providing consistent visual integration with light and dark modes.

## Development Notes

This project demonstrates production-quality iOS development practices including clean architecture with separation of concerns, comprehensive error handling for robust user experience, memory-efficient design suitable for keyboard extensions, secure API key management with multiple configuration options, and modern SwiftUI implementation following Apple's design guidelines.

The codebase is fully documented with clear comments explaining complex logic and design decisions. All major components include proper error handling and edge case management to ensure reliable operation across different usage scenarios.

For questions or support with this implementation, refer to the comprehensive documentation files included in the project or review the inline code comments for specific technical details.

## Technical Assumptions and Design Decisions

### Audio Recording Configuration
The keyboard uses M4A audio format with 44.1kHz sample rate. This provides excellent voice quality while keeping file sizes manageable for network transmission. Recording is limited to 60 seconds maximum to prevent memory issues in the keyboard extension environment and encourage concise voice input.

### Network and API Settings  
Network requests timeout after 30 seconds to balance user experience with reliability. The system assumes internet connectivity is available for transcription services. API responses typically take 2-5 seconds for short audio clips.

### User Interface Design
The keyboard height is set to 280 points to provide adequate space for the voice recording interface while remaining compact. Press-and-hold interaction is used as it's familiar to users from voice messaging applications. The interface provides immediate visual feedback to touch interactions.

### iOS Compatibility and Requirements
VoiceBoard targets iOS 15.0 and later to take advantage of modern SwiftUI features while maintaining broad device compatibility. The keyboard requires "Allow Full Access" permission to make network requests for audio transcription.

### Security and Privacy Considerations
Voice recordings are stored temporarily in the app's sandbox and automatically deleted after transcription. Audio data is only transmitted to Groq's API for processing and is not stored permanently on the device. The API key is stored securely using iOS standard practices.

## Development and Testing

### Code Quality Standards
The project follows iOS development best practices including proper memory management with weak references, comprehensive error handling for all edge cases, clean separation of concerns with modular architecture, and extensive documentation for all classes and methods.

### Testing Approach
The keyboard has been designed to work reliably across different iOS devices including both iPhone and iPad with universal layout compatibility. Memory usage is optimized for keyboard extension constraints. Network error scenarios are thoroughly handled with user-friendly error messages.

### Extension Compliance
VoiceBoard fully complies with iOS App Extension guidelines including memory limitations, network usage restrictions, and proper permission handling. The extension uses temporary file storage with automatic cleanup and implements secure communication patterns.

## Performance Optimization

### Memory Management
The keyboard automatically manages memory by limiting recording duration, cleaning up temporary audio files, using efficient audio compression, and implementing proper object lifecycle management with weak references to prevent memory leaks.

### Network Efficiency
API requests use efficient multipart form-data encoding. The system includes automatic retry logic for failed requests and implements proper timeout handling to avoid hanging network connections.

## Troubleshooting Common Issues

### Permissions
- **Microphone Access**: Required for voice recording functionality
- **Network Access**: Required for API communication (needs Full Access)
- **No Location/Contacts**: No access to sensitive device data

### API Security
- **HTTPS Only**: All API communications use secure HTTPS
- **Bearer Authentication**: Secure API key-based authentication
- **No Audio Storage**: Groq API processes audio without permanent storage

##  Error Handling

The keyboard handles various error scenarios gracefully:

### Permission Errors
- **Microphone Denied**: Clear message with settings guidance
- **Full Access Disabled**: Informative error about network limitations

### Recording Errors
- **Recording Failed**: Hardware or system-level recording issues
- **File Creation Failed**: Storage or permission problems

### Network Errors
- **No Internet**: Connection unavailable
- **API Timeout**: Request took too long
- **Server Error**: API service issues
- **Invalid API Key**: Authentication problems

### Audio Errors
- **Empty Recording**: No speech detected in audio
- **Corrupted File**: Audio file processing failed

##  Testing

### Manual Testing Checklist
- [ ] Main app launches and requests microphone permission
- [ ] Setup instructions are clear and actionable
- [ ] Keyboard can be enabled in iOS Settings
- [ ] Full Access permission can be granted
- [ ] Voice recording starts on press and hold
- [ ] Visual feedback (waveform, button states) works correctly
- [ ] Haptic feedback occurs on press and release
- [ ] Transcription completes successfully
- [ ] Text is inserted correctly at cursor position
- [ ] Error states display appropriate messages
- [ ] Light and dark mode support works

### Device Testing
- **iPhone**: Test on various iPhone models and iOS versions
- **iPad**: Ensure keyboard layout adapts to larger screens
- **Simulator**: Useful for UI testing (limited audio functionality)

##  Future Enhancements

### Potential Improvements
- **Multiple Language Support**: UI localization for global users
- **Custom Vocabulary**: Support for technical terms or proper nouns
- **Offline Mode**: Local speech recognition for privacy-conscious users
- **Voice Commands**: Support for formatting commands ("new paragraph", "comma")
- **Quick Phrases**: Predefined phrases for common responses

### Technical Optimizations
- **Audio Compression**: Reduce file sizes for faster upload
- **Background Processing**: Continue transcription when app is backgrounded
- **Caching**: Cache common phrases to reduce API calls
- **Analytics**: Usage metrics for improving user experience



---

**VoiceBoard** - Transforming voice into text with the power of AI 🎤→📝

