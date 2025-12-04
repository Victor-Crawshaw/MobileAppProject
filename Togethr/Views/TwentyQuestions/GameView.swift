import SwiftUI
import Speech

struct GameView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    let category: String
    let secretWord: String
    
    // Logic State
    @StateObject private var speechRecognizer = SpeechRecognizer() // Helper class for STT
    @State private var questionLog: [RecordedQuestion] = [] // History of Q&A
    @State private var currentQuestionText: String = "" // Current input
    @State private var questionAwaitingAnswer: Bool = false // Toggle between Input Mode and Answer Mode
    @State private var showingQuestionLog = false
    
    // UI State
    @FocusState private var isInputActive: Bool // Keyboard focus state
    
    var body: some View {
        ZStack {
            // MARK: 1. Background (Deep Space)
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Background tap to dismiss keyboard
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    isInputActive = false
                }
            
            // Ambient Glow
            GeometryReader { geo in
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.2)
            }
            
            VStack(spacing: 0) {
                
                // MARK: 2. HUD Header
                HStack {
                    // Abort Button (Resets stack)
                    Button(action: { navPath = NavigationPath() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark.circle.fill")
                            Text("ABORT GAME")
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Category Badge
                    Text("TARGET: \(category.uppercased())")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(1)
                        .padding(6)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(Color.teal.opacity(0.3)))
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                // MARK: 3. Question Counter
                // Big number display showing current question index (1-20)
                VStack(spacing: 0) {
                    Text("QUESTION UPLINK")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(2)
                    
                    Text("\(questionLog.count + 1)")
                        .font(.system(size: 100, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.white, .teal], startPoint: .top, endPoint: .bottom)
                        )
                        .shadow(color: .teal.opacity(0.6), radius: 15, x: 0, y: 0)
                }
                
                // MARK: 4. The "Comms" Box (Input Area)
                // Displays either the Speech Transcription or Text Field
                VStack(spacing: 15) {
                    ZStack {
                        // Glass Background Style
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(red: 0.1, green: 0.1, blue: 0.15).opacity(0.9))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .strokeBorder(
                                        LinearGradient(colors: [.purple.opacity(0.5), .teal.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                            // Make the whole box tap-to-type
                            .onTapGesture {
                                isInputActive = true
                            }
                        
                        VStack {
                            if speechRecognizer.isRecording {
                                // Recording Animation State
                                HStack(spacing: 8) {
                                    Circle().fill(Color.red).frame(width: 10, height: 10).opacity(0.8)
                                    Text("RECEIVING TRANSMISSION...")
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                        .foregroundColor(.red)
                                }
                                .padding(.bottom, 5)
                                
                                Text(speechRecognizer.transcript.isEmpty ? "Listening..." : speechRecognizer.transcript)
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                            } else {
                                // Manual Text Input Mode
                                VStack(spacing: 5) {
                                    TextField("Type or Record Question...", text: $currentQuestionText, axis: .vertical)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .submitLabel(.done)
                                        .focused($isInputActive)
                                        .onChange(of: currentQuestionText) { newValue in
                                            // Ensure we are in "answering mode" if the user types manually
                                            if !newValue.isEmpty {
                                                questionAwaitingAnswer = true
                                            }
                                        }
                                    
                                    // Hint (only if empty and not typing)
                                    if currentQuestionText.isEmpty && !isInputActive {
                                        Text("Tap here to type manually")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.3))
                                            .padding(.top, 5)
                                    }
                                }
                            }
                        }
                        .padding(20)
                    }
                    .frame(minHeight: 140)
                    
                    // MARK: 5. Input Controls (Mic & Keyboard)
                    HStack(spacing: 15) {
                        
                        if speechRecognizer.isRecording {
                            // Stop Button
                            Button(action: {
                                speechRecognizer.stopTranscribing()
                            }) {
                                Label("STOP", systemImage: "stop.fill")
                                    .font(.system(size: 16, weight: .black, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.red.opacity(0.2))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red, lineWidth: 2))
                                    .foregroundColor(.red)
                            }
                        } else {
                            // Record Button
                            Button(action: {
                                if questionAwaitingAnswer {
                                    resetCurrentQuestion()
                                } else {
                                    speechRecognizer.startTranscribing()
                                }
                            }) {
                                Image(systemName: questionAwaitingAnswer ? "arrow.clockwise" : "mic.fill")
                                    .font(.system(size: 24))
                                    .frame(width: 80, height: 60)
                                    .background(questionAwaitingAnswer ? Color.orange.opacity(0.2) : Color.teal.opacity(0.2))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(questionAwaitingAnswer ? Color.orange : Color.teal, lineWidth: 2))
                                    .foregroundColor(questionAwaitingAnswer ? .orange : .teal)
                            }
                            .cornerRadius(16)
                            
                            // Keyboard / Type Button (Manual Bypass)
                            Button(action: {
                                isInputActive = true
                            }) {
                                HStack {
                                    Image(systemName: "keyboard.fill")
                                    Text("TYPE QUESTION")
                                }
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color.blue.opacity(0.2))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.blue, lineWidth: 2))
                                .foregroundColor(.blue)
                            }
                            .cornerRadius(16)
                            .opacity(questionAwaitingAnswer ? 0.5 : 1.0) // Dim if already waiting for answer
                            .disabled(questionAwaitingAnswer)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: 6. Yes/No Buttons
                // Enabled only when a question is pending
                HStack(spacing: 20) {
                    Button(action: { logAnswer(answer: .yes) }) {
                        Text("YES")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(questionAwaitingAnswer ? Color.green.opacity(0.2) : Color.white.opacity(0.05))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(questionAwaitingAnswer ? Color.green : Color.white.opacity(0.1), lineWidth: 2))
                            .foregroundColor(questionAwaitingAnswer ? .green : .white.opacity(0.2))
                    }
                    .disabled(!questionAwaitingAnswer)
                    .cornerRadius(16)
                    
                    Button(action: { logAnswer(answer: .no) }) {
                        Text("NO")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(questionAwaitingAnswer ? Color.red.opacity(0.2) : Color.white.opacity(0.05))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(questionAwaitingAnswer ? Color.red : Color.white.opacity(0.1), lineWidth: 2))
                            .foregroundColor(questionAwaitingAnswer ? .red : .white.opacity(0.2))
                    }
                    .disabled(!questionAwaitingAnswer)
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: 7. Log, Undo & Win Buttons
                VStack(spacing: 12) {
                    
                    HStack(spacing: 10) {
                        // LOG BUTTON (Shows history)
                        Button(action: { showingQuestionLog = true }) {
                            HStack {
                                Image(systemName: "list.bullet.clipboard")
                                Text("QUESTION LOG (\(questionLog.count))")
                            }
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(Color.white.opacity(0.1))
                            .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                        
                        // UNDO BUTTON (Removes last entry)
                        if !questionLog.isEmpty {
                            Button(action: { undoLastLog() }) {
                                HStack {
                                    Image(systemName: "arrow.uturn.backward")
                                    Text("UNDO")
                                }
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(Color.red.opacity(0.1))
                                .overlay(Capsule().stroke(Color.red.opacity(0.5), lineWidth: 1))
                                .foregroundColor(.red)
                                .clipShape(Capsule())
                            }
                        }
                    }
                    
                    // WIN BUTTON (Manually triggered by Knower)
                    Button(action: {
                        navPath.append(GameNavigation.twentyQuestionsResult(
                            didWin: true,
                            questionLog: questionLog,
                            category: category,
                            secretWord: secretWord
                        ))
                    }) {
                        Text("THEY GUESSED IT!")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.yellow.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.yellow, lineWidth: 2))
                            .foregroundColor(.yellow)
                            .shadow(color: .yellow.opacity(0.3), radius: 8)
                    }
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true) // We are handling back manually via Abort
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
        // Auto-switch to "Answering Mode" when speech recording finishes
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
    
    // MARK: - Logic Functions
    
    // Clears input and resets controls for next turn
    func resetCurrentQuestion() {
        currentQuestionText = ""
        speechRecognizer.resetTranscript()
        questionAwaitingAnswer = false
        isInputActive = false
    }
    
    // Removes the most recent question/answer pair
    func undoLastLog() {
        guard !questionLog.isEmpty else { return }
        // Remove the last item
        questionLog.removeLast()
        // Ensure we aren't in a stuck state
        resetCurrentQuestion()
    }
    
    // Records the answer and checks for Game Over (Loss)
    func logAnswer(answer: Answer) {
        isInputActive = false
        
        let newLogEntry = RecordedQuestion(questionText: currentQuestionText, answer: answer)
        questionLog.append(newLogEntry)
        
        resetCurrentQuestion()
        
        // If 20 questions reached, trigger loss
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

// MARK: - Updated Log Sheet (Dark Mode Style)
struct StyledQuestionLogSheetView: View {
    @Environment(\.dismiss) var dismiss
    let questionLog: [RecordedQuestion]
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Sheet Header
                HStack {
                    Spacer()
                    Text("QUESTION LOG")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .tracking(2)
                    Spacer()
                }
                .overlay(alignment: .trailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                
                // List Content
                if questionLog.isEmpty {
                    Spacer()
                    Text("NO DATA RECORDED")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(questionLog) { log in
                        HStack(alignment: .top) {
                            // Status Icon (Check/X)
                            Image(systemName: log.answer == .yes ? "checkmark.circle" : "xmark.circle")
                                .foregroundColor(log.answer == .yes ? .green : .red)
                                .font(.headline)
                                .padding(.top, 2)
                            
                            // Question & Answer Text
                            VStack(alignment: .leading) {
                                Text(log.questionText)
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.white)
                                // Changed "Outcome" to "Answer"
                                Text("ANSWER: \(log.answer.rawValue.uppercased())")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(log.answer == .yes ? .green : .red)
                            }
                            Spacer()
                        }
                        .listRowBackground(Color.white.opacity(0.05))
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                
                // Close Button
                Button(action: { dismiss() }) {
                    Text("CLOSE LOG")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
    }
}
