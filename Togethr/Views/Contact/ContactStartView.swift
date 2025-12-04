// Views/Contact/ContactStartView.swift
import SwiftUI

struct ContactStartView: View {
    
    @Binding var navPath: NavigationPath
    @State private var showingHowToPlay = false
    
    // Add dismiss environment to return to Home
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // MARK: 1. Deep Space Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Ambient Orbs
            GeometryReader { geo in
                Circle().fill(Color.teal.opacity(0.2)).frame(width: 300).blur(radius: 60).offset(x: -100, y: -100)
                Circle().fill(Color.purple.opacity(0.2)).frame(width: 300).blur(radius: 60).offset(x: geo.size.width - 150, y: geo.size.height / 2)
            }
            
            VStack(spacing: 40) {
                
                // MARK: 2. Navigation Header (Added Back Button)
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading, 20)
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
                
                // MARK: 3. Hero Title
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.blue.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom))
                            .frame(width: 180, height: 180)
                            .blur(radius: 10)
                        
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(LinearGradient(colors: [.cyan, .blue], startPoint: .top, endPoint: .bottom))
                            .shadow(color: .blue, radius: 10)
                    }
                    
                    Text("CONTACT")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .blue.opacity(0.5), radius: 10)
                    
                    Text("Word Defender Protocol")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(2)
                }
                
                Spacer()
                
                // MARK: 4. Action Buttons
                VStack(spacing: 20) {
                    // Start Game
                    Button(action: {
                        navPath.append(GameNavigation.contactWordSetup)
                    }) {
                        Text("INITIATE GAME")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                            .shadow(color: .teal.opacity(0.5), radius: 10, y: 5)
                    }
                    .buttonStyle(BouncyGameButtonStyle())
                    
                    // How to Play
                    Button(action: {
                        showingHowToPlay = true
                    }) {
                        Text("HOW TO PLAY")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .buttonStyle(BouncyGameButtonStyle())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingHowToPlay) {
            ContactHowToPlayView()
                .preferredColorScheme(.dark)
        }
    }
}


