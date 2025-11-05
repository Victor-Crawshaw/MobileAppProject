// ViewModels/SpeechRecognizer.swift
import AVFoundation
import Foundation
import Speech
import SwiftUI

/// An observable object that manages speech recognition.
class SpeechRecognizer: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var transcript: String = ""
    @Published var isRecording: Bool = false
    @Published var error: String?
    
    // MARK: - Private Properties
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    
    /// Requests authorization for speech recognition and microphone access.
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.error = nil
                case .denied:
                    self.error = "Speech recognition authorization was denied."
                case .restricted:
                    self.error = "Speech recognition is restricted on this device."
                case .notDetermined:
                    self.error = "Speech recognition has not been authorized."
                @unknown default:
                    self.error = "Unknown authorization error."
                }
            }
        }
    }
    
    /// Starts the transcription process.
    func startTranscribing() {
        guard !isRecording else { return }
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            self.error = "Speech recognizer is not available."
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = self.recognitionRequest else {
                fatalError("Unable to create SFSpeechAudioBufferRecognitionRequest object")
            }
            recognitionRequest.shouldReportPartialResults = true
            
            self.recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }
                
                var isFinal = false
                
                if let result = result {
                    self.transcript = result.bestTranscription.formattedString
                    isFinal = result.isFinal
                }
                
                if error != nil || isFinal {
                    self.stopRecording()
                }
            }
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            self.isRecording = true
            self.transcript = "" // Reset transcript
            
        } catch {
            self.error = "Audio engine failed to start: \(error.localizedDescription)"
            self.stopRecording()
        }
    }
    
    /// Stops the transcription process.
    func stopTranscribing() {
        guard isRecording else { return }
        self.stopRecording()
    }
    
    /// Resets the transcript for the next question.
    func resetTranscript() {
        self.transcript = ""
    }
    
    /// Private helper to stop all audio processing.
    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        recognitionRequest = nil
        recognitionTask = nil
        
        DispatchQueue.main.async {
            self.isRecording = false
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            self.error = "Failed to deactivate audio session: \(error.localizedDescription)"
        }
    }
}
