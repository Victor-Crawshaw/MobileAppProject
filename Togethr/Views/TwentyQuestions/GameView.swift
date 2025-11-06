// Views/TwentyQuestions/GameView.swift
import SwiftUI
import Speech

struct GameView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    
    // 1. ADD: It now knows the secret word
    let secretWord: String
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var questionLog: [RecordedQuestion] = []
    @State private var currentQuestionText: String = ""
    @State private var questionAwaitingAnswer: Bool = false
    @State private var showingQuestionLog = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Question")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text("\(questionLog.count + 1)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
            
            // This is the VStack with the live-transcription update
            VStack {
                if speechRecognizer.isRecording {
                    Text(speechRecognizer.transcript.isEmpty ? "Listening..." : speechRecognizer.transcript)
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .cornerRadius(12)
                        .frame(minHeight: 60)
                } else {
                    if currentQuestionText.isEmpty {
                        Text("Tap the mic to ask a question.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(minHeight: 60)
                    } else {
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
                    .disabled(questionAwaitingAnswer)
                }
            }
            .padding()
            
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
                .disabled(!questionAwaitingAnswer)
                
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
                .disabled(!questionAwaitingAnswer)
            }
            
            Spacer()
            
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
                // 2. MODIFIED: Pass the secretWord to the result
                navPath.append(GameNavigation.twentyQuestionsResult(
                    didWin: true,
                    questionLog: questionLog,
                    category: category,
                    secretWord: secretWord // Pass it here
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
            if !isRecording && !speechRecognizer.transcript.isEmpty {
                self.currentQuestionText = speechRecognizer.transcript
                self.questionAwaitingAnswer = true
            }
        }
        .sheet(isPresented: $showingQuestionLog) {
            QuestionLogSheetView(questionLog: questionLog)
        }
    }
    
    // 3. MODIFIED: The logAnswer function must also pass the secretWord
    func logAnswer(answer: Answer) {
        let newLogEntry = RecordedQuestion(questionText: currentQuestionText, answer: answer)
        questionLog.append(newLogEntry)
        
        currentQuestionText = ""
        speechRecognizer.resetTranscript()
        questionAwaitingAnswer = false
        
        if questionLog.count >= 20 {
            // Used up 20 questions
            navPath.append(GameNavigation.twentyQuestionsResult(
                didWin: false,
                questionLog: questionLog,
                category: category,
                secretWord: secretWord // Pass it here too
            ))
        }
    }
}

// (The QuestionLogSheetView struct is unchanged)
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
        .presentationDetents([.medium, .large])
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(
            navPath: .constant(NavigationPath()),
            category: "Animals",
            secretWord: "Sloth" // Add mock data
        )
    }
}
