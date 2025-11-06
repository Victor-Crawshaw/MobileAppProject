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
        VStack(spacing: 20) {
            
            // Top Section (Win/Loss)
            VStack(spacing: 15) {
                if didWin {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    Text("They Guessed It!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // 3. NEW: Show the word
                    Text("The secret was: \(secretWord)")
                        .font(.title3)
                    
                    Text(questionLog.count == 1 ? "It only took 1 question!" : "It only took \(questionLog.count) questions!")
                        .font(.headline)
                        .foregroundColor(.secondary)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                    Text("They Failed!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // 3. NEW: Show the word
                    Text("The secret was: \(secretWord)")
                        .font(.title3)
                    
                    Text("They couldn't guess the \(category.dropLast(1)) in 20 questions!")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.vertical)
            
            Text("Game Log")
                .font(.title2)
                .fontWeight(.bold)
            
            List(questionLog) { log in
                HStack {
                    Image(systemName: log.answer == .yes ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(log.answer == .yes ? .green : .red)
                        .font(.headline)
                    
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
            
            // Bottom Buttons
            VStack(spacing: 10) {
                Button(action: {
                    // MODIFIED: We now pop 4 views to get back to CategorySelection
                    // Result, Game, Confirmation, SecretInput
                    navPath.removeLast(4)
                }) {
                    Text("Play Again")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    navPath.removeLast(navPath.count)
                }) {
                    Text("Main Menu")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .foregroundColor(.primary)
                        .font(.headline)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
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
