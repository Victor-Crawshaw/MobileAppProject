// Views/TwentyQuestions/ResultView.swift
import SwiftUI

struct ResultView: View {
    
    @Binding var navPath: NavigationPath
    
    let didWin: Bool
    let questionLog: [RecordedQuestion]
    let category: String
    
    // 1. ADD: It now accepts the secret word
    let secretWord: String
    
    // 2. MODIFIED: Updated init
    init(navPath: Binding<NavigationPath>, didWin: Bool, questionLog: [RecordedQuestion], category: String, secretWord: String) {
        self._navPath = navPath
        self.didWin = didWin
        self.questionLog = questionLog
        self.category = category
        self.secretWord = secretWord
    }
    
    var body: some View {
        // NEW: ZStack for gradient
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
                
                // Top Section (Win/Loss)
                VStack(spacing: 15) {
                    if didWin {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                        
                        Text("They Guessed It!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        // 3. NEW: Show the word
                        Text("The secret was: \(secretWord)")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        Text(questionLog.count == 1 ? "It only took 1 question!" : "It only took \(questionLog.count) questions!")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.red)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                        
                        Text("They Didn't Guess!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        // 3. NEW: Show the word
                        Text("The secret was: \(secretWord)")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        Text("You stumped them!")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                // Question Log
                VStack(alignment: .leading) {
                    Text("Question Log")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    List(questionLog) { log in
                        HStack {
                            Text(log.answer == .yes ? "✅" : "❌")
                            Text(log.questionText)
                        }
                    }
                    .scrollContentBackground(.hidden) // Make List bg transparent
                    .cornerRadius(12)
                }
                
                // Bottom Buttons
                VStack(spacing: 15) {
                    // MODIFIED: "Play Again" button (Green Capsule)
                    Button(action: {
                        // Pop 4 views: Result, Game, Confirm, SecretInput
                        navPath.removeLast(4)
                    }) {
                        Text("Play Again")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color.green.gradient)
                            )
                            .foregroundColor(.white)
                    }
                    
                    // MODIFIED: "Main Menu" button (Stroked Capsule)
                    Button(action: {
                        navPath.removeLast(navPath.count)
                    }) {
                        Text("Main Menu")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .stroke(Color.white.opacity(0.7), lineWidth: 2)
                                    .fill(Color.white.opacity(0.2))
                            )
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ResultView_Previews: PreviewProvider {
    static let mockLog: [RecordedQuestion] = [
        RecordedQuestion(questionText: "Does it live in the water?", answer: .yes),
        RecordedQuestion(questionText: "Is it a mammal?", answer: .yes),
        RecordedQuestion(questionText: "Is it a dolphin?", answer: .no)
    ]
    
    static var previews: some View {
        ResultView(
            navPath: .constant(NavigationPath()),
            didWin: true,
            questionLog: mockLog,
            category: "Animals",
            secretWord: "Whale" // Add mock data
        )
        
        ResultView(
            navPath: .constant(NavigationPath()),
            didWin: false,
            questionLog: mockLog,
            category: "Animals",
            secretWord: "Whale" // Add mock data
        )
    }
}
