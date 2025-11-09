// Views/TwentyQuestions/GameView.swift
import SwiftUI
import Speech

struct GameView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    let secretWord: String
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var questionLog: [RecordedQuestion] = []
    @State private var currentQuestionText: String = ""
    @State private var questionAwaitingAnswer: Bool = false
    @State private var showingQuestionLog = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.7),
                    Color.cyan.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                Text("Question")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(questionLog.count + 1)")
                    .font(.system(size: 100, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                
                VStack(spacing: 15) {
                    
                    VStack {
                        if speechRecognizer.isRecording {
                            Text(speechRecognizer.transcript.isEmpty ? "Listening..." : speechRecognizer.transcript)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        } else {
                            if currentQuestionText.isEmpty {
                                Text("Tap the mic to ask a question.")
                                    .font(.headline)
                                    .foregroundColor(.primary.opacity(0.8))
                            } else {
                                Text(currentQuestionText)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 60)
                    .background(.regularMaterial)
                    .cornerRadius(20)
                    
                    // --- MODIFICATION START ---
                    // This block is updated to handle the "Re-record" state
                    
                    if speechRecognizer.isRecording {
                        Button(action: {
                            speechRecognizer.stopTranscribing()
                        }) {
                            Label("Stop Recording", systemImage: "stop.fill")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Capsule().fill(Color.red.gradient))
                                .foregroundColor(.white)
                        }
                    } else {
                        // This button is now dual-purpose: Record or Re-record
                        Button(action: {
                            if questionAwaitingAnswer {
                                // Action 1: Re-record
                                resetCurrentQuestion()
                            } else {
                                // Action 2: Start recording
                                speechRecognizer.startTranscribing()
                            }
                        }) {
                            // The label changes based on the state
                            if questionAwaitingAnswer {
                                Label("Re-record Question", systemImage: "arrow.clockwise")
                            } else {
                                Label("Record Question", systemImage: "mic.fill")
                            }
                        }
                        .font(.headline)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        // The background color also changes
                        .background(Capsule().fill(
                            questionAwaitingAnswer ? Color.orange.gradient : Color.blue.gradient
                        ))
                        .foregroundColor(.white)
                        // The .disabled modifier is no longer needed
                    }
                    
                    // --- MODIFICATION END ---
                }
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button(action: {
                        logAnswer(answer: .yes)
                    }) {
                        Text("Yes")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .background(Capsule().fill(Color.green.gradient))
                            .foregroundColor(.white)
                    }
                    .disabled(!questionAwaitingAnswer) // This correctly disables/enables
                    
                    Button(action: {
                        logAnswer(answer: .no)
                    }) {
                        Text("No")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .background(Capsule().fill(Color.red.gradient))
                            .foregroundColor(.white)
                    }
                    .disabled(!questionAwaitingAnswer) // This correctly disables/enables
                }
                .padding(.horizontal)
                
                Spacer()
                
                if !questionLog.isEmpty {
                    Button(action: {
                        showingQuestionLog = true
                    }) {
                        Text("View Question Log (\(questionLog.count))")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 10)
                }
                
                Button(action: {
                    navPath.append(GameNavigation.twentyQuestionsResult(
                        didWin: true,
                        questionLog: questionLog,
                        category: category,
                        secretWord: secretWord
                    ))
                }) {
                    Text("They Guessed It!")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .background( // Use secondary button style
                            Capsule()
                                .stroke(Color.yellow.opacity(0.7), lineWidth: 2)
                                .fill(Color.yellow.opacity(0.2))
                        )
                        .foregroundColor(.yellow)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
        .onChange(of: speechRecognizer.isRecording) { isRecording in
            if !isRecording && !speechRecognizer.transcript.isEmpty {
                self.currentQuestionText = speechRecognizer.transcript
                self.questionAwaitingAnswer = true
            }
        }
        .sheet(isPresented: $showingQuestionLog) {
            StyledQuestionLogSheetView(questionLog: questionLog)
        }
    }
    
    // --- NEW FUNCTION ---
    // Resets the UI to allow for a new recording attempt
    func resetCurrentQuestion() {
        currentQuestionText = ""
        speechRecognizer.resetTranscript()
        questionAwaitingAnswer = false
    }
    // --- END NEW FUNCTION ---
    
    func logAnswer(answer: Answer) {
        let newLogEntry = RecordedQuestion(questionText: currentQuestionText, answer: answer)
        questionLog.append(newLogEntry)
        
        // This logic is now safe because resetCurrentQuestion() is separate
        currentQuestionText = ""
        speechRecognizer.resetTranscript()
        questionAwaitingAnswer = false
        
        if questionLog.count >= 20 {
            navPath.append(GameNavigation.twentyQuestionsResult(
                didWin: false,
                questionLog: questionLog,
                category: category,
                secretWord: secretWord
            ))
        }
    }
}

// StyledQuestionLogSheetView is UNCHANGED
struct StyledQuestionLogSheetView: View {
    @Environment(\.dismiss) var dismiss
    let questionLog: [RecordedQuestion]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text("Question Log")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .overlay(alignment: .trailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary.opacity(0.5))
                }
            }
            .padding(.top)
            
            if questionLog.isEmpty {
                Spacer()
                Text("No questions have been asked yet.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                List(questionLog) { log in
                    HStack(alignment: .top) {
                        Image(systemName: log.answer == .yes ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(log.answer == .yes ? .green : .red)
                            .font(.headline)
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading) {
                            Text(log.questionText)
                                .font(.body)
                            Text("Answer: \(log.answer.rawValue.capitalized)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(InsetGroupedListStyle())
            }
            
            Button(action: {
                dismiss()
            }) {
                Text("Close")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .background(
                        Capsule()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                            .fill(Color.gray.opacity(0.1))
                    )
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .presentationDetents([.medium, .large])
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameView(
                navPath: .constant(NavigationPath()),
                category: "Animals",
                secretWord: "Sloth"
            )
        }
    }
}
