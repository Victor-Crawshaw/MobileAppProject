import Foundation

struct Game: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let modes: [GameMode]
    let emoji: String // For the visual menu
}

extension Game {
    static let mockData: [Game] = [
        Game(name: "20 Questions",
             description: "Guess the secret item in 20 'yes' or 'no' questions.",
             modes: [.inPerson],
             emoji: "🤔"),
        
        Game(name: "Contact",
             description: "Guess the secret word, one letter at a time.",
             modes: [.inPerson],
             emoji: "🔤"),
        
        Game(name: "Hangman",
             description: "Guess the word letter by letter before running out of tries.",
             modes: [.inPerson, .passAndPlay],
             emoji: "🎯"),

        Game(name: "Telepathy",
             description: "Draw. Guess. Draw. Watch the message distort.",
             modes: [.passAndPlay, .inPerson],
             emoji: "🧠")
    ]
}
