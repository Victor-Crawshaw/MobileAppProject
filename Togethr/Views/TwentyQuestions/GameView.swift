import SwiftUI
import Speech

struct GameView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    
    // UI Helper State (Speech stays in View as it interacts with hardware)
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    // Logic extracted to specific ViewModel
    @StateObject private var viewModel: TwentyQuestionsGameViewModel
    
    // UI-Specific State
    @State private var showingQuestionLog = false
    @FocusState private var isInputActive: Bool
    
    // MARK: - Init
    init(navPath: Binding<NavigationPath>, category: String, secretWord: String) {
        self._navPath = navPath
        // Initialize the specific ViewModel
        self._viewModel = StateObject(wrappedValue: TwentyQuestionsGameViewModel(category: category, secretWord: secretWord))
    }
    
    // MARK: - Main Body
    // Broken down into sub-vars to prevent "Compiler unable to type-check" errors
    var body: some View {
        ZStack {
            backgroundLayer
            
            VStack(spacing: 0) {
                headerView
                
                Spacer()
                
                questionCounterView
                
                // Grouping the center console area
                VStack(spacing: 15) {
                    commsConsoleView
                    inputControlsView
                }
                .padding(.horizontal)
                
                Spacer()
                
                answerButtonsView
                
                Spacer()
                
                bottomToolsView
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
        // Auto-switch to "Answering Mode" when speech recording finishes
        .onChange(of: speechRecognizer.isRecording) { isRecording in
            if !isRecording && !speechRecognizer.transcript.isEmpty {
                // Pass transcript to ViewModel
                viewModel.submitQuestion(speechRecognizer.transcript)
            }
        }
        .sheet(isPresented: $showingQuestionLog) {
            StyledQuestionLogSheetView(questionLog: viewModel.questionLog)
        }
    }
}

// MARK: - Subviews (Refactored to fix compiler timeout)
extension GameView {
    
    // 1. Background Visuals
    private var backgroundLayer: some View {
        ZStack {
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
        }
    }
    
    // 2. Top Header (Abort & Category)
    private var headerView: some View {
        HStack {
            // Abort Button
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
            Text("TARGET: \(viewModel.category.uppercased())")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(.teal)
                .tracking(1)
                .padding(6)
                .background(RoundedRectangle(cornerRadius: 4).stroke(Color.teal.opacity(0.3)))
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    // 3. The Big Number
    private var questionCounterView: some View {
        VStack(spacing: 0) {
            Text("QUESTION UPLINK")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white.opacity(0.5))
                .tracking(2)
            
            Text("\(viewModel.questionLog.count + 1)")
                .font(.system(size: 100, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [.white, .teal], startPoint: .top, endPoint: .bottom)
                )
                .shadow(color: .teal.opacity(0.6), radius: 15, x: 0, y: 0)
        }
    }
    
    // 4. The Glass Box (Text or Speech Display)
    private var commsConsoleView: some View {
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
                .onTapGesture {
                    isInputActive = true
                }
            
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
                    // Manual Text Input
                    VStack(spacing: 5) {
                        TextField("Type or Record Question...", text: $viewModel.currentQuestionText, axis: .vertical)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .submitLabel(.done)
                            .focused($isInputActive)
                            .onChange(of: viewModel.currentQuestionText) { newValue in
                                if !newValue.isEmpty {
                                    viewModel.questionAwaitingAnswer = true
                                }
                            }
                        
                        // Hint
                        if viewModel.currentQuestionText.isEmpty && !isInputActive {
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
    }
    
    // 5. Mic and Keyboard Buttons
    private var inputControlsView: some View {
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
                // Mic Button
                Button(action: {
                    if viewModel.questionAwaitingAnswer {
                        // Reset question
                        viewModel.cancelQuestion()
                        speechRecognizer.resetTranscript()
                        isInputActive = false
                    } else {
                        speechRecognizer.startTranscribing()
                    }
                }) {
                    Image(systemName: viewModel.questionAwaitingAnswer ? "arrow.clockwise" : "mic.fill")
                        .font(.system(size: 24))
                        .frame(width: 80, height: 60)
                        .background(viewModel.questionAwaitingAnswer ? Color.orange.opacity(0.2) : Color.teal.opacity(0.2))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(viewModel.questionAwaitingAnswer ? Color.orange : Color.teal, lineWidth: 2))
                        .foregroundColor(viewModel.questionAwaitingAnswer ? .orange : .teal)
                }
                .cornerRadius(16)
                
                // Keyboard Button
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
                .opacity(viewModel.questionAwaitingAnswer ? 0.5 : 1.0)
                .disabled(viewModel.questionAwaitingAnswer)
            }
        }
    }
    
    // 6. Yes / No Buttons
    private var answerButtonsView: some View {
        HStack(spacing: 20) {
            Button(action: {
                isInputActive = false
                viewModel.provideAnswer(.yes)
                checkGameEnd()
            }) {
                Text("YES")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(viewModel.questionAwaitingAnswer ? Color.green.opacity(0.2) : Color.white.opacity(0.05))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(viewModel.questionAwaitingAnswer ? Color.green : Color.white.opacity(0.1), lineWidth: 2))
                    .foregroundColor(viewModel.questionAwaitingAnswer ? .green : .white.opacity(0.2))
            }
            .disabled(!viewModel.questionAwaitingAnswer)
            .cornerRadius(16)
            
            Button(action: {
                isInputActive = false
                viewModel.provideAnswer(.no)
                checkGameEnd()
            }) {
                Text("NO")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(viewModel.questionAwaitingAnswer ? Color.red.opacity(0.2) : Color.white.opacity(0.05))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(viewModel.questionAwaitingAnswer ? Color.red : Color.white.opacity(0.1), lineWidth: 2))
                    .foregroundColor(viewModel.questionAwaitingAnswer ? .red : .white.opacity(0.2))
            }
            .disabled(!viewModel.questionAwaitingAnswer)
            .cornerRadius(16)
        }
        .padding(.horizontal)
    }
    
    // 7. Log, Undo, Win
    private var bottomToolsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                // LOG BUTTON
                Button(action: { showingQuestionLog = true }) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard")
                        Text("QUESTION LOG (\(viewModel.questionLog.count))")
                    }
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.white.opacity(0.1))
                    .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                
                // UNDO BUTTON
                if !viewModel.questionLog.isEmpty {
                    Button(action: {
                        viewModel.undoLastLog()
                        isInputActive = false
                    }) {
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
            
            // WIN BUTTON
            Button(action: {
                navPath.append(GameNavigation.twentyQuestionsResult(
                    didWin: true,
                    questionLog: viewModel.questionLog,
                    category: viewModel.category,
                    secretWord: viewModel.secretWord
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
    
    // Helper
    private func checkGameEnd() {
        if viewModel.questionLog.count >= 20 {
            navPath.append(GameNavigation.twentyQuestionsResult(
                didWin: false,
                questionLog: viewModel.questionLog,
                category: viewModel.category,
                secretWord: viewModel.secretWord
            ))
        }
        speechRecognizer.resetTranscript()
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
                            // Status Icon
                            Image(systemName: log.answer == .yes ? "checkmark.circle" : "xmark.circle")
                                .foregroundColor(log.answer == .yes ? .green : .red)
                                .font(.headline)
                                .padding(.top, 2)
                            
                            // Question & Answer Text
                            VStack(alignment: .leading) {
                                Text(log.questionText)
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.white)
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
