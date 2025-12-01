import SwiftUI
import Speech

struct GameView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    let secretWord: String
    
    // Logic State
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var questionLog: [RecordedQuestion] = []
    @State private var currentQuestionText: String = ""
    @State private var questionAwaitingAnswer: Bool = false
    @State private var showingQuestionLog = false
    
    // UI State
    @FocusState private var isInputActive: Bool // New: To manage keyboard focus
    
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
            
            // Ambient Glow (Star/Nebula effect)
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
                    // Back/Abort Button
                    Button(action: { navPath = NavigationPath() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark.circle.fill")
                            Text("ABORT")
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
                
                // MARK: 3. Question Counter (Scoreboard)
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
                
                // MARK: 4. The "Comms" Box (Transcription)
                VStack(spacing: 15) {
                    ZStack {
                        // Glass Background
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
                        
                        VStack {
                            if speechRecognizer.isRecording {
                                // Recording Animation
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
                                if currentQuestionText.isEmpty && !isInputActive {
                                    // Idle State
                                    VStack(spacing: 8) {
                                        Image(systemName: "waveform")
                                            .foregroundColor(.white.opacity(0.2))
                                            .font(.title)
                                        Text("Tap MIC to transmit query")
                                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                } else {
                                    // Result State (Editable)
                                    VStack(spacing: 5) {
                                        TextField("Type Question...", text: $currentQuestionText, axis: .vertical)
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
                                        
                                        // Edit hint
                                        if !isInputActive {
                                            HStack(spacing: 4) {
                                                Image(systemName: "pencil")
                                                Text("Tap text to edit")
                                            }
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.3))
                                            .padding(.top, 5)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                    }
                    .frame(minHeight: 140)
                    
                    // MARK: 5. Logic Button (Record / Stop / Re-Record)
                    if speechRecognizer.isRecording {
                        Button(action: {
                            speechRecognizer.stopTranscribing()
                        }) {
                            Label("STOP TRANSMISSION", systemImage: "stop.fill")
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.red.opacity(0.2))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red, lineWidth: 2))
                                .foregroundColor(.red)
                                .shadow(color: .red.opacity(0.4), radius: 10)
                        }
                        .cornerRadius(16)
                    } else {
                        // This handles both Start and Re-record based on state
                        Button(action: {
                            if questionAwaitingAnswer {
                                resetCurrentQuestion()
                            } else {
                                speechRecognizer.startTranscribing()
                            }
                        }) {
                            if questionAwaitingAnswer {
                                Label("RE-RECORD", systemImage: "arrow.clockwise")
                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.orange.opacity(0.2))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.orange, lineWidth: 2))
                                    .foregroundColor(.orange)
                            } else {
                                Label("INITIATE RECORDING", systemImage: "mic.fill")
                                    .font(.system(size: 16, weight: .black, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color.teal.opacity(0.2))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.teal, lineWidth: 2))
                                    .foregroundColor(.teal)
                                    .shadow(color: .teal.opacity(0.4), radius: 10)
                            }
                        }
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: 6. Yes/No Buttons
                HStack(spacing: 20) {
                    Button(action: { logAnswer(answer: .yes) }) {
                        Text("YES")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            // Visual disable state
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
                            // Visual disable state
                            .background(questionAwaitingAnswer ? Color.red.opacity(0.2) : Color.white.opacity(0.05))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(questionAwaitingAnswer ? Color.red : Color.white.opacity(0.1), lineWidth: 2))
                            .foregroundColor(questionAwaitingAnswer ? .red : .white.opacity(0.2))
                    }
                    .disabled(!questionAwaitingAnswer)
                    .cornerRadius(16)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: 7. Log & Win Buttons
                VStack(spacing: 12) {
                    if !questionLog.isEmpty {
                        Button(action: { showingQuestionLog = true }) {
                            Text("ACCESS MISSION LOG (\(questionLog.count))")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.teal)
                        }
                    }
                    
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
    
    // --- FUNCTIONS ---
    
    func resetCurrentQuestion() {
        currentQuestionText = ""
        speechRecognizer.resetTranscript()
        questionAwaitingAnswer = false
        isInputActive = false
    }
    
    func logAnswer(answer: Answer) {
        // Dismiss keyboard if open
        isInputActive = false
        
        let newLogEntry = RecordedQuestion(questionText: currentQuestionText, answer: answer)
        questionLog.append(newLogEntry)
        
        // Reset using the specific reset logic
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

// MARK: - Updated Log Sheet (Dark Mode Style)
struct StyledQuestionLogSheetView: View {
    @Environment(\.dismiss) var dismiss
    let questionLog: [RecordedQuestion]
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Text("MISSION LOG")
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
                
                if questionLog.isEmpty {
                    Spacer()
                    Text("NO DATA RECORDED")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.gray)
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
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.white)
                                Text("OUTCOME: \(log.answer.rawValue.uppercased())")
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

// Preview
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
