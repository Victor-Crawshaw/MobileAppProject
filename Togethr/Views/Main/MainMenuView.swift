// Views/Main/MainMenuView.swift
import SwiftUI

// NEW: Enum to manage the filter state, including an "All" option
enum GameFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case inPerson = "In-Person"
    case online = "Online"
    case passAndPlay = "Pass-and-Play"
    
    var id: String { self.rawValue }
}

struct MainMenuView: View {
    
    @State private var navPath = NavigationPath()
    
    // NEW: State to track the selected filter
    @State private var selectedFilter: GameFilter = .all
    
    private let allGames: [Game] = Game.mockData
    
    private let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    // NEW: Computed property to filter games based on the selected state
    private var filteredGames: [Game] {
        switch selectedFilter {
        case .all:
            return allGames
        case .inPerson:
            return allGames.filter { $0.mode == .inPerson }
        case .online:
            return allGames.filter { $0.mode == .online }
        case .passAndPlay:
            return allGames.filter { $0.mode == .passAndPlay }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                // MODIFIED: Made the gradient more vibrant and "fun"
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.teal.opacity(0.6),
                        Color.purple.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) { // Increased spacing
                        
                        // MODIFIED: Styled the title to pop more
                        Text("Togethr")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white) // Changed color
                            .shadow(color: .black.opacity(0.2), radius: 5, y: 3) // Added shadow
                            .padding(.top, 40)
                        
                        // NEW: Filter Picker
                        Picker("Filter Games", selection: $selectedFilter) {
                            ForEach(GameFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)

                        // MODIFIED: Grid now uses 'filteredGames' and animates
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredGames) { game in // Use filteredGames
                                NavigationLink(value: navigationValue(for: game)) {
                                    GameCard(game: game)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedFilter) // Animate changes
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            
            // ==========================================================
            // This navigationDestination section is UNCHANGED from yours
            // ==========================================================
            .navigationDestination(for: GameNavigation.self) { destination in
                switch destination {
                
                // --- 20 Questions Flow ---
                case .twentyQuestionsStart:
                    TwentyQuestionsStartView(navPath: $navPath)
                    
                case .twentyQuestionsCategory:
                    CategorySelectionView(navPath: $navPath)
                    
                case .twentyQuestionsSecretInput(let category):
                    TwentyQuestionsSecretInputView(navPath: $navPath, category: category)
                    
                case .twentyQuestionsConfirm(let category, let secretWord):
                    ConfirmationView(navPath: $navPath, category: category, secretWord: secretWord)
                    
                case .twentyQuestionsGame(let category, let secretWord):
                    GameView(navPath: $navPath, category: category, secretWord: secretWord)
                        
                case .twentyQuestionsResult(let didWin, let questionLog, let category, let secretWord):
                    ResultView(navPath: $navPath, didWin: didWin, questionLog: questionLog, category: category, secretWord: secretWord)
                
                // --- Contact Flow ---
                case .contactStart:
                    ContactStartView(navPath: $navPath)
            
                case .contactWordSetup:
                    ContactWordSetupView(navPath: $navPath)
            
                case .contactGame(let secretWord):
                    ContactGameView(navPath: $navPath, secretWord: secretWord)

                case .contactResult(let didGuessersWin, let secretWord, let reason):
                    ContactResultView(
                        navPath: $navPath,
                        didGuessersWin: didGuessersWin,
                        secretWord: secretWord,
                        reason: reason
                    )

                }
            }
        }
    }
    
    // This ViewBuilder function is UNCHANGED
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
    
    // This helper function is UNCHANGED
    private func navigationValue(for game: Game) -> GameNavigation {
        switch game.name {
        case "20 Questions":
            return .twentyQuestionsStart
        case "Contact":
            return .contactStart
        default:
            // Fallback for new games like Charades, etc.
            // You can expand this later.
            return .twentyQuestionsStart
        }
    }
}

// UNCHANGED PREVIEW
struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
