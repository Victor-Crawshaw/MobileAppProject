import SwiftUI

struct GameView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    
    // 1. Start count at 1 for "Question 1"
    @State private var questionCount = 1
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Question")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text("\(questionCount)")
                .font(.system(size: 80, weight: .bold, design: .rounded))
            
            Text("Guesser, ask your Yes/No question.\nKnower, press a button after your answer.")
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    advanceQuestion(answeredYes: true)
                }) {
                    Text("Yes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    advanceQuestion(answeredYes: false)
                }) {
                    Text("No")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
            }
            
            Spacer()
            
            // 3. "Guessed It" button now appends to the path
            Button(action: {
                navPath.append(GameNavigation.twentyQuestionsResult(
                    didWin: true,
                    questionCount: questionCount,
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
    }
    
    // 5. Updated game logic
    func advanceQuestion(answeredYes: Bool) {
        // This logic handles 20 questions (1-20)
        // The 21st press (when count is 20) triggers the 'else'
        if questionCount < 20 {
            questionCount += 1
        } else {
            // Used up 20 questions, this is the fail state
            navPath.append(GameNavigation.twentyQuestionsResult(
                didWin: false,
                questionCount: 20,
                category: category
            ))
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(navPath: .constant(NavigationPath()), category: "Animals")
    }
}

