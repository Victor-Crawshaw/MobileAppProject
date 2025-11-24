// Views/Main/MainMenuView.swift
import SwiftUI

enum GameFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case inPerson = "In-Person"
    case online = "Online"
    case passAndPlay = "Pass & Play"
    
    var id: String { self.rawValue }
}

struct MainMenuView: View {
    
    @State private var navPath = NavigationPath()
    @State private var selectedFilter: GameFilter = .all
    
    private let allGames: [Game] = Game.mockData
    
    private let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
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
                    VStack(spacing: 25) {
                        
                        Text("Togethr")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 5, y: 3)
                            .padding(.top, 40)
                        
                        Picker("Filter Games", selection: $selectedFilter) {
                            ForEach(GameFilter.allCases) { filter in
                                Text(filter.rawValue)
                                    .font(.caption)
                                    .tag(filter)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)

                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredGames) { game in
                                NavigationLink(value: navigationValue(for: game)) {
                                    GameCard(game: game)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedFilter)
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            
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
                
                // --- Hangman Flow ---
                case .hangmanStart:
                    HangmanStartView(navPath: $navPath)
                
                case .hangmanWordSetup:
                    HangmanWordSetupView(navPath: $navPath)
                
                case .hangmanConfirm(let secretWord):
                    HangmanConfirmationView(navPath: $navPath, secretWord: secretWord)
                
                case .hangmanGame(let secretWord):
                    HangmanGameView(navPath: $navPath, secretWord: secretWord)
                
                case .hangmanResult(let didWin, let secretWord, let incorrectGuesses):
                    HangmanResultView(navPath: $navPath, didWin: didWin, secretWord: secretWord, incorrectGuesses: incorrectGuesses)
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
    
    private func navigationValue(for game: Game) -> GameNavigation {
        switch game.name {
        case "20 Questions":
            return .twentyQuestionsStart
        case "Contact":
            return .contactStart
        case "Hangman":
            return .hangmanStart
        default:
            return .twentyQuestionsStart
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}