# VoiceBoard Quick Setup Instructions

## Fast Setup Process for iOS Development

This guide provides streamlined setup instructions for quickly configuring and running the VoiceBoard keyboard extension project.

## Prerequisites and Requirements

Before beginning setup, ensure you have macOS operating system with Xcode 15.0 or later installed from the Mac App Store. You will also need an iOS device or simulator running iOS 15.0 or later for testing the keyboard functionality.

Obtain a free Groq API key by visiting the Groq Console website at https://console.groq.com and creating a developer account. The API key is required for voice transcription functionality and must be configured before testing the keyboard.

## API Key Configuration Process

### Primary Configuration Method

Open the VoiceBoard project in Xcode and navigate to the VoiceBoardKeyboard folder in the project navigator. Locate and open the Info.plist file which contains the keyboard extension configuration settings.

Find the GROQ_API_KEY entry in the Info.plist file. Replace the placeholder text "your_groq_api_key_here" with your actual Groq API key obtained from the console. Save the file after making this change.

### Alternative Configuration Options

For development environments where you prefer not to embed API keys in source files, you can use environment variable configuration. In Xcode, access the Product menu, select Scheme, then Edit Scheme. Under the Run section, click Environment Variables and add GROQ_API_KEY as the variable name with your API key as the value.

For runtime configuration during development or testing, you can programmatically set the API key using the Configuration class methods provided in the project. This approach is useful for dynamic key management scenarios.

## Project Build and Execution

### Opening and Building

Double-click the VoiceBoard.xcodeproj file to open the project in Xcode. The project will load with both the main application target and keyboard extension target properly configured with all necessary dependencies.

Select your target iOS device or simulator from the device selection menu in Xcode. For initial testing, the iOS Simulator provides adequate functionality for keyboard testing and development.

Build the project by pressing Command+B or selecting Build from the Product menu. The build process should complete successfully without errors if all prerequisites are met and API key is properly configured.

### Running and Testing

Run the project by pressing Command+R or selecting Run from the Product menu. This will install the application on your selected device or simulator and launch the main VoiceBoard application.

The main application will request microphone permission which is required for voice recording functionality. Grant this permission to enable full keyboard capabilities.

Follow the setup instructions displayed in the main application to enable the VoiceBoard keyboard in iOS Settings. The app provides direct navigation assistance and step-by-step guidance for the keyboard activation process.

### Keyboard Activation

Navigate to iOS Settings, then General, then Keyboard, then Keyboards. Select "Add New Keyboard" and choose VoiceBoard from the list of available keyboards. Enable "Allow Full Access" for VoiceBoard to permit network requests for transcription.

### Testing Voice Functionality

Open any application with text input capability such as Messages, Notes, or email. Tap the globe icon on the standard keyboard to switch to VoiceBoard. The custom keyboard interface should appear with a large microphone button in the center.

Press and hold the microphone button to begin voice recording. The interface should provide immediate visual feedback with button color changes and waveform animation. Speak clearly while holding the button, then release to initiate transcription.

## Troubleshooting Common Setup Issues

### Build or Compilation Problems

If the project fails to build, verify that your Xcode version is 15.0 or later and that iOS SDK 15.0 or later is installed. Check that your API key is properly configured in the Info.plist file and does not contain the placeholder text.

Ensure that both the main application and keyboard extension targets are properly configured with correct bundle identifiers and signing certificates. Clean the build folder using Command+Shift+K if persistent build issues occur.

### Keyboard Not Appearing

If VoiceBoard does not appear in the keyboard list, ensure the application built and installed successfully without errors. Restart your device or simulator after installation to refresh the keyboard extension registration.

Verify that both targets compiled successfully and that the keyboard extension bundle was properly installed alongside the main application. Check the device console for any error messages related to extension loading.

### Recording or API Issues

If voice recording does not start, confirm that microphone permission was granted to the main VoiceBoard application. Permission must be granted to the main app, not the keyboard extension, due to iOS security model.

For transcription problems, verify your internet connection and API key validity. Test the API key independently if necessary to ensure it has appropriate permissions for the Whisper transcription service.

Check that "Allow Full Access" is enabled for VoiceBoard in keyboard settings, as this permission is required for network requests from keyboard extensions.

## Quick Validation Steps

After successful setup, perform these quick validation steps to confirm proper operation:

Test basic functionality by recording a short voice message and verifying text insertion. Test error handling by temporarily disabling internet connection and confirming appropriate error messages. Verify theme adaptation by switching between light and dark mode in iOS Settings.

Test cross-application compatibility by using the keyboard in different applications including Messages, Notes, and social media apps. Confirm that the keyboard maintains consistent functionality across different usage contexts.

The setup process should complete within minutes once all prerequisites are met. The comprehensive documentation and clear configuration instructions ensure smooth setup for technical evaluation and testing purposes.
