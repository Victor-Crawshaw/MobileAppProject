// Views/Main/MainMenuView.swift
import SwiftUI

struct MainMenuView: View {
    
    // 1. Add state for the navigation path
    @State private var navPath = NavigationPath()
    
    private let allGames: [Game] = Game.mockData
    
    private let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        // 2. Bind the path to the NavigationStack
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
                                // 3. Change to NavigationLink(value:)
                                // This adds a value to the navPath instead of a view
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
            // 4. Add .navigationDestination to handle all path values
            .navigationDestination(for: GameNavigation.self) { destination in
                // This view builder routes to the correct view
                switch destination {
                case .twentyQuestionsStart:
                    TwentyQuestionsStartView(navPath: $navPath)
                
                // --- MODIFIED: Pass navPath ---
                case .contactStart:
                    ContactStartView(navPath: $navPath) // Pass the path
                
                case .twentyQuestionsCategory:
                    CategorySelectionView(navPath: $navPath)
                case .twentyQuestionsConfirm(let category):
                    ConfirmationView(navPath: $navPath, category: category)
                case .twentyQuestionsGame(let category):
                    GameView(navPath: $navPath, category: category)
                case .twentyQuestionsResult(let didWin, let questionLog, let category):
                    ResultView(navPath: $navPath, didWin: didWin, questionLog: questionLog, category: category)
                    
                // --- NEW: Add Contact destinations ---
                case .contactPlayerSetup:
                    ContactPlayerSetupView(navPath: $navPath)
                
                case .contactGame(let players, let secretWord):
                    ContactGameView(navPath: $navPath, players: players, secretWord: secretWord)
                    
                case .contactResult(let winner, let secretWord):
                    ContactResultView(navPath: $navPath, winner: winner, secretWord: secretWord)
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
    
    // 5. Helper to return the correct navigation value
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