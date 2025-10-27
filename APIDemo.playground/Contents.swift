import Foundation
import PlaygroundSupport

// Custom error for throws
enum APIError: Error {
    case emptyResponse
    case badURL
}

// Core struct (from models) - Fixed with explicit init for Codable compatibility
struct Prompt: Codable, Identifiable {
    let id: UUID
    let text: String
    
    init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
    
    // CodingKeys to skip id during potential decoding (uses default)
    enum CodingKeys: String, CodingKey {
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        id = UUID()  // Generate fresh ID on decode
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
    }
}

// Fetch and format
func fetchGamePrompt(gameType: String) async throws -> Prompt {
    guard let url = URL(string: "https://random-word-api.herokuapp.com/word?number=1") else {
        throw APIError.badURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    // Optional: Validate HTTP response (good practice)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    let words = try JSONDecoder().decode([String].self, from: data)
    guard let word = words.first else { throw APIError.emptyResponse }
    
    let formatted: String
    switch gameType {
    case "contact": formatted = word.uppercased()  // e.g., "ELEPHANT" for letter chain
    case "story": formatted = "a \(word) adventure"  // e.g., "a banana adventure"
    case "twenty": formatted = "an \(word)"  // e.g., "an elephant" for secret
    default: formatted = word.capitalized
    }
    
    return Prompt(text: formatted)
}

// Examples
Task {
    do {
        let contactPrompt = try await fetchGamePrompt(gameType: "contact")
        print("Contact Starter: \(contactPrompt.text)")  // e.g., "ELEPHANT"
        
        let storyPrompt = try await fetchGamePrompt(gameType: "story")
        print("Story Spark: \(storyPrompt.text)")  // e.g., "a banana adventure"
        
        let twentyPrompt = try await fetchGamePrompt(gameType: "twenty")
        print("20Q Secret: \(twentyPrompt.text)")  // e.g., "an elephant"
        
        print("All prompts fetched and parsed successfully!")
    } catch {
        print("Error: \(error.localizedDescription)")
        // Fallback example
        let fallback = Prompt(text: "A Dancing Robot")
        print("Fallback Prompt: \(fallback.text)")
    }
    
    PlaygroundPage.current.finishExecution()
}
