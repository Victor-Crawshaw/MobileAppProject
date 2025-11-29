// Views/Hangman/HangmanHowToPlayView.swift
import SwiftUI

struct HangmanHowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("TACTICAL GUIDE")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.orange)
                    .padding(.top, 30)
                
                Text("Hangman Rules")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        InstructionBlock(
                            title: "1. The Setup",
                            text: "One player (the Chooser) enters a secret word or phrase."
                        )
                        
                        InstructionBlock(
                            title: "2. The Guess",
                            text: "The Guesser taps letters on the keypad to reveal them in the secret word."
                        )
                        
                        InstructionBlock(
                            title: "3. The Danger",
                            text: "Every incorrect guess adds a piece to the stick figure. You have 6 lives (Head, Body, 2 Arms, 2 Legs)."
                        )
                        
                        InstructionBlock(
                            title: "4. Victory Condition",
                            text: "Reveal the entire word before the figure is complete to win. If the figure is finished first, you lose."
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
