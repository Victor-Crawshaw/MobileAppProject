import SwiftUI

struct ResultView: View {
    
    // 1. This binding will now be valid!
    @Binding var navPath: NavigationPath
    
    let didWin: Bool
    let questionCount: Int
    let category: String
    
    init(navPath: Binding<NavigationPath>, didWin: Bool, questionCount: Int, category: String) {
        self._navPath = navPath
        self.didWin = didWin
        self.questionCount = questionCount
        self.category = category
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if didWin {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                Text("They Guessed It!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(questionCount == 1 ? "It only took 1 question!" : "It only took \(questionCount) questions!")
                    .font(.headline)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
                Text("They Failed!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("They couldn't guess the \(category.dropLast(1)) in 20 questions!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // 2. This button will now work!
            Button(action: {
                // Pop 3 views: Result, Game, Confirmation
                // This lands you back on CategorySelectionView
                navPath.removeLast(3)
            }) {
                Text("Play Again")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(1/2)
            }
            
            // 3. This button will also work!
            Button(action: {
                // Pop all views to return to the root (MainMenuView)
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
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(navPath: .constant(NavigationPath()), didWin: true, questionCount: 7, category: "Animals")
        
        ResultView(navPath: .constant(NavigationPath()), didWin: false, questionCount: 20, category: "Animals")
    }
}

