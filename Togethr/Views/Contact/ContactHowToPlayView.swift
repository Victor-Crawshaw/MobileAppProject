// Views/Contact/ContactHowToPlayView.swift
import SwiftUI

struct ContactHowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("TACTICAL GUIDE")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.teal)
                    .padding(.top, 30)
                
                Text("How to Play")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        InstructionBlock(
                            title: "1. The Defender",
                            text: "One player thinks of a Secret Word (e.g. 'ASTEROID') and gives the first letter ('A')."
                        )
                        
                        InstructionBlock(
                            title: "2. The Guessers",
                            text: "Everyone else thinks of words starting with 'A'. They give clues to each other: 'Is it a fruit?'"
                        )
                        
                        InstructionBlock(
                            title: "3. Contact!",
                            text: "If another Guesser knows the clue (e.g. 'APPLE'), they say 'CONTACT!'. Then both count down '3, 2, 1...' and say their words."
                        )
                        
                        InstructionBlock(
                            title: "4. The Reveal",
                            text: "If the words match, the Defender must reveal the next letter of the Secret Word ('S'). If the Defender guesses the clue first, no letter is revealed."
                        )
                    }
                    .padding(30)
                }

                Button(action: { dismiss() }) {
                    Text("UNDERSTOOD")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(20)
                .background(Color(red: 0.05, green: 0.0, blue: 0.15))
            }
        }
    }
}

struct InstructionBlock: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(.purple)
            Text(text)
                .font(.body)
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
    }
}
