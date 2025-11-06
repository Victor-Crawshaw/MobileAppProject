// Views/TwentyQuestions/GameView.swift
import SwiftUI
import Speech // Import the Speech framework

struct GameView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    
    // 1. View model for speech recognition
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    // 2. State to hold the log of questions and answers
    @State private var questionLog: [RecordedQuestion] = []
    
    // 3. State to hold the current question's text after recording
    @State private var currentQuestionText: String = ""
    
    // 4. State to control when Yes/No buttons are active
    @State private var questionAwaitingAnswer: Bool = false
    
    // 5. NEW: State to control the presentation of the question log
    @State private var showingQuestionLog = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Question")
                .font(.title)
                .foregroundColor(.secondary)
            
            // Display question number based on the log count
            Text("\(questionLog.count + 1)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
            
            // ==========================================================
            // MODIFIED: This block now shows the live transcript
            // ==========================================================
            VStack {
                if speechRecognizer.isRecording {
                    // Show the LIVE transcript as it's being recorded
                    // Use a placeholder if the transcript is empty
                    Text(speechRecognizer.transcript.isEmpty ? "Listening..." : speechRecognizer.transcript)
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .cornerRadius(12)
                        .frame(minHeight: 60) // Use minHeight for consistency
                    
                } else {
                    // This is the original behavior
                    if currentQuestionText.isEmpty {
                        // Show the default prompt
                        Text("Tap the mic to ask a question.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(minHeight: 60) // Use minHeight for consistency
                    } else {
                        // Display the confirmed, final question
                        Text(currentQuestionText)
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.regularMaterial)
                            .cornerRadius(12)
                            .frame(minHeight: 60)
                    }
                }
                
                // Record / Stop button
                if speechRecognizer.isRecording {
                    Button(action: {
                        speechRecognizer.stopTranscribing()
                    }) {
                        Label("Stop Recording", systemImage: "stop.fill")
                            .font(.headline)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                } else {
                    Button(action: {
                        speechRecognizer.startTranscribing()
                    }) {
                        Label("Record Question", systemImage: "mic.fill")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    // Disable record button if a question is waiting for an answer
                    .disabled(questionAwaitingAnswer)
                }
            }
            .padding()
            // ==========================================================
            // End of Modified Block
            // ==========================================================
            
            // Yes/No answer buttons
            HStack(spacing: 20) {
                Button(action: {
                    logAnswer(answer: .yes)
                }) {
                    Text("Yes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                .disabled(!questionAwaitingAnswer) // Disable if no question is recorded
                
                Button(action: {
                    logAnswer(answer: .no)
                }) {
                    Text("No")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                .disabled(!questionAwaitingAnswer) // Disable if no question is recorded
            }
            
            Spacer()
            
            // 6. NEW: Button to show the question log
            if !questionLog.isEmpty {
                Button(action: {
                    showingQuestionLog = true
                }) {
                    Text("View Question Log (\(questionLog.count))")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 10)
            }
            
            // "Guessed It" button
            Button(action: {
                navPath.append(GameNavigation.twentyQuestionsResult(
                    didWin: true,
                    questionLog: questionLog, // Pass the whole log
                    category: category
                ))
            }) {
                Text("They Guessed It!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .font(.headline)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
        .onChange(of: speechRecognizer.isRecording) { isRecording in
            // When recording stops, update the UI state
            if !isRecording && !speechRecognizer.transcript.isEmpty {
                self.currentQuestionText = speechRecognizer.transcript
                self.questionAwaitingAnswer = true
            }
        }
        // 7. NEW: Sheet modifier to present the log
        .sheet(isPresented: $showingQuestionLog) {
            QuestionLogSheetView(questionLog: questionLog)
        }
    }
    
    // Updated game logic
    func logAnswer(answer: Answer) {
        // Create the log entry
        let newLogEntry = RecordedQuestion(questionText: currentQuestionText, answer: answer)
        questionLog.append(newLogEntry)
        
        // Reset for the next question
        currentQuestionText = ""
        speechRecognizer.resetTranscript()
        questionAwaitingAnswer = false
        
        // Check for 20 questions limit
        if questionLog.count >= 20 {
            // Used up 20 questions, this is the fail state
            navPath.append(GameNavigation.twentyQuestionsResult(
                didWin: false,
                questionLog: questionLog, // Pass the log
                category: category
            ))
        }
    }
}

// 8. NEW: A simple view for the sheet content
// (This struct stays in the same file)
struct QuestionLogSheetView: View {
    @Environment(\.dismiss) var dismiss
    let questionLog: [RecordedQuestion]
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
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
            
            // Log List
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
            
            // Close Button
            Button(action: {
                dismiss()
            }) {
                Text("Close")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
        }
        .padding()
        // Prevents the sheet from being a small "detent"
        .presentationDetents([.medium, .large])
    }
}


// UNCHANGED PREVIEW
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(navPath: .constant(NavigationPath()), category: "Animals")
    }
}
