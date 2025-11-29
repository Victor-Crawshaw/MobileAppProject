import SwiftUI

// --- Enum (Unchanged) ---
enum GameFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case inPerson = "In-Person"
    case online = "Online"
    case passAndPlay = "Pass & Play"
    
    var id: String { self.rawValue }
}

// --- Custom Button Style for the "Game Feel" ---
struct BouncyGameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct MainMenuView: View {
    
    @State private var navPath = NavigationPath()
    @State private var selectedFilter: GameFilter = .all
    
    // Mock Data Hook
    private let allGames: [Game] = Game.mockData
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 20)
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
                // MARK: 1. Gamey Background
                // Deep space/gaming purple background
                Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
                
                // Ambient Glow Orbs
                GeometryReader { geo in
                    Circle()
                        .fill(Color.teal.opacity(0.2))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60)
                        .offset(x: geo.size.width - 150, y: geo.size.height / 2)
                }
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // MARK: 2. Header
                        VStack(spacing: 5) {
                            Text("TOGETHR")
                                .font(.system(size: 42, weight: .black, design: .rounded))
                                .tracking(2) // Spacing out letters looks more cinematic
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 0)
                            
                            Text("SELECT YOUR CHALLENGE")
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.6))
                                .kerning(1.5)
                        }
                        .padding(.top, 40)
                        
                        // MARK: 3. Custom Filter Bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(GameFilter.allCases) { filter in
                                    FilterButton(filter: filter, selectedFilter: $selectedFilter)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // MARK: 4. Game Grid
                        LazyVGrid(columns: columns, spacing: 25) {
                            ForEach(filteredGames) { game in
                                NavigationLink(value: navigationValue(for: game)) {
                                    GameCardView(game: game)
                                }
                                .buttonStyle(BouncyGameButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                        .animation(.spring(), value: selectedFilter)
                    }
                }
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark) // Force dark mode for game aesthetic
            
            // MARK: Navigation Destinations
            .navigationDestination(for: GameNavigation.self) { destination in
                switch destination {
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
                    
                case .contactStart:
                    ContactStartView(navPath: $navPath)
                case .contactWordSetup:
                    ContactWordSetupView(navPath: $navPath)
                
                // UPDATED: Now handles timeLimit
                case .contactGame(let secretWord, let timeLimit):
                    ContactGameView(navPath: $navPath, secretWord: secretWord, timeLimit: timeLimit)
                    
                case .contactResult(let didGuessersWin, let secretWord, let reason):
                    ContactResultView(navPath: $navPath, didGuessersWin: didGuessersWin, secretWord: secretWord, reason: reason)
                    
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
    
    // MARK: Helper Functions
    private func navigationValue(for game: Game) -> GameNavigation {
        switch game.name {
        case "20 Questions": return .twentyQuestionsStart
        case "Contact": return .contactStart
        case "Hangman": return .hangmanStart
        default: return .twentyQuestionsStart
        }
    }
}

// --- Subviews ---

struct FilterButton: View {
    let filter: GameFilter
    @Binding var selectedFilter: GameFilter
    
    var isSelected: Bool {
        selectedFilter == filter
    }
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedFilter = filter
            }
        } label: {
            Text(filter.rawValue.uppercased())
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.teal : Color.white.opacity(0.1))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
                )
                .foregroundColor(isSelected ? .black : .white)
                .shadow(color: isSelected ? .teal.opacity(0.8) : .clear, radius: 10)
        }
        .buttonStyle(BouncyGameButtonStyle())
    }
}

struct GameCardView: View {
    let game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Emoji Container
            HStack {
                Text(game.emoji)
                    .font(.system(size: 45))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                Spacer()
                
                // Little decorative icon
                Image(systemName: "gamecontroller.fill")
                    .foregroundColor(.white.opacity(0.1))
                    .font(.title3)
            }
            .padding(.bottom, 20)
            
            Spacer()
            
            // Text Content
            Text(game.name.uppercased())
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .padding(.bottom, 4)
            
            Text(game.description)
                .font(.system(size: 11, weight: .medium, design: .default))
                .foregroundColor(.gray)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(height: 180)
        .background(
            ZStack {
                // Card Background
                Color(red: 0.1, green: 0.1, blue: 0.12)
                
                // Subtle Gradient Overlay
                LinearGradient(
                    colors: [.white.opacity(0.05), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        // The "Border"
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [.teal.opacity(0.6), .purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
