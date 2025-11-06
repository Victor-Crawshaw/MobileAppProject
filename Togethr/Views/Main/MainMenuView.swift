// Views/Main/MainMenuView.swift
import SwiftUI

struct MainMenuView: View {
    
    @State private var navPath = NavigationPath()
    
    private let allGames: [Game] = Game.mockData
    
    private let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Text("Togethr")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .padding(.top, 40)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(allGames) { game in
                                NavigationLink(value: navigationValue(for: game)) {
                                    GameCard(game: game)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            
            // ==========================================================
            // MODIFIED: This section is updated with all new destinations
            // ==========================================================
            .navigationDestination(for: GameNavigation.self) { destination in
                switch destination {
                
                // --- 20 Questions Flow ---
                case .twentyQuestionsStart:
                    TwentyQuestionsStartView(navPath: $navPath)
                    
                case .twentyQuestionsCategory:
                    CategorySelectionView(navPath: $navPath)
                    
                // NEW: Handles the secret input view
                case .twentyQuestionsSecretInput(let category):
                    TwentyQuestionsSecretInputView(navPath: $navPath, category: category)
                    
                // UPDATED: Handles the modified confirmation view
                case .twentyQuestionsConfirm(let category, let secretWord):
                    ConfirmationView(navPath: $navPath, category: category, secretWord: secretWord)
                    
                // UPDATED: Handles the modified game view
                case .twentyQuestionsGame(let category, let secretWord):
                    GameView(navPath: $navPath, category: category, secretWord: secretWord)
                        
                // UPDATED: Handles the modified result view
                case .twentyQuestionsResult(let didWin, let questionLog, let category, let secretWord):
                    ResultView(navPath: $navPath, didWin: didWin, questionLog: questionLog, category: category, secretWord: secretWord)
                
                // --- Contact Flow ---
                case .contactStart:
                    ContactStartView(navPath: $navPath)
            
                case .contactWordSetup:
                    ContactWordSetupView(navPath: $navPath)
            
                case .contactGame(let secretWord):
                    // You'll need to create this view
                    // ContactGameView(navPath: $navPath, secretWord: secretWord)
                    Text("Contact Game View (secret: \(secretWord))") // Placeholder
            
                case .contactResult(let didGuessersWin, let secretWord, let reason):
                    // You'll need to create this view
                    // ContactResultView(navPath: $navPath, didGuessersWin: didGuessersWin, secretWord: secretWord, reason: reason)
                     Text("Contact Result View") // Placeholder
                }
            }
        }
    }
    
    @ViewBuilder
    private func GameCard(game: Game) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(game.emoji)
                .font(.system(size: 50))
            
            Spacer()
            
            Text(game.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(game.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .frame(height: 180, alignment: .topLeading)
        .background(.regularMaterial)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // Helper to return the correct navigation value
    private func navigationValue(for game: Game) -> GameNavigation {
        switch game.name {
        case "20 Questions":
            return .twentyQuestionsStart
        case "Contact":
            return .contactStart
        default:
            return .twentyQuestionsStart // Fallback
        }
    }
}

// UNCHANGED PREVIEW
struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
