// Views/Contact/ContactStartView.swift
import SwiftUI

struct ContactStartView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    @State private var showingHowToPlay = false
    
    // Access the dismiss action to return to the previous Home/Root screen
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // MARK: 1. Deep Space Background
            // Consistent dark theme background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // MARK: Ambient Orbs
            // Blurred circles to create a "space" atmosphere
            GeometryReader { geo in
                Circle().fill(Color.teal.opacity(0.2)).frame(width: 300).blur(radius: 60).offset(x: -100, y: -100)
                Circle().fill(Color.purple.opacity(0.2)).frame(width: 300).blur(radius: 60).offset(x: geo.size.width - 150, y: geo.size.height / 2)
            }
            
            VStack(spacing: 40) {
                
                // MARK: 2. Navigation Header
                // Custom "Back" button to pop this view from the stack
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
                // Large "Contact" logo with stylistic shadows and fonts
                VStack(spacing: 15) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 80))
                        .foregroundColor(.teal)
                        .shadow(color: .purple, radius: 20)
                    
                    Text("CONTACT")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.teal, .purple], startPoint: .leading, endPoint: .trailing)
                        )
                        .shadow(color: .teal.opacity(0.5), radius: 10)
                    
                    Text("WORD DEFENSE")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .tracking(6)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // MARK: 4. Action Buttons
                VStack(spacing: 20) {
                    
                    // Start Game Button -> Navigates to Setup
                    Button(action: {
                        navPath.append(GameNavigation.contactWordSetup)
                    }) {
                        Text("INITIATE PROTOCOL")
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
                    .buttonStyle(BouncyGameButtonStyle()) // Helper style for press animation
                    
                    // How to Play Button -> Opens Modal Sheet
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
