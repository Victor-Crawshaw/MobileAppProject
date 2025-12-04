// Views/Telestrations/TelestrationsStartView.swift
import SwiftUI

struct TelestrationsStartView: View {
    @Binding var navPath: NavigationPath
    @State private var playerCount: Int = 4
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Ambient Orbs
            GeometryReader { geo in
                Circle().fill(Color.purple.opacity(0.15)).frame(width: 300).blur(radius: 60).offset(x: -50, y: -50)
                Circle().fill(Color.teal.opacity(0.15)).frame(width: 300).blur(radius: 60).offset(x: geo.size.width - 150, y: geo.size.height / 2)
            }
            
            VStack(spacing: 40) {
                
                // Navigation Header (Back Button)
                HStack {
                    Button(action: {
                        if !navPath.isEmpty { navPath.removeLast() }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("Main Menu")
                        }
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading, 20)
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
                
                // MARK: Hero Title
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.purple.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                            .frame(width: 180, height: 180)
                            .blur(radius: 10)
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 80))
                            .foregroundStyle(LinearGradient(colors: [.teal, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: .purple.opacity(0.5), radius: 10)
                    }
                    
                    Text("TELEPATHY")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .teal.opacity(0.5), radius: 10, x: 0, y: 5)
                        .tracking(2)
                    
                    Text("Draw. Guess. Distort.")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                        .tracking(1)
                }
                
                Spacer()
                
                // MARK: Player Count Selector
                VStack(spacing: 20) {
                    Text("PLAYER COUNT: \(playerCount)")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(2)
                    
                    HStack(spacing: 30) {
                        Button(action: { if playerCount > 2 { playerCount -= 1 } }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(playerCount > 2 ? .white : .gray)
                        }
                        
                        // Visual representation of players
                        HStack(spacing: -10) {
                            ForEach(0..<min(playerCount, 8), id: \.self) { _ in
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 2)
                                    .background(Circle().fill(Color.purple.opacity(0.5)))
                                    .frame(width: 30, height: 30)
                            }
                            if playerCount > 8 {
                                Text("+\(playerCount - 8)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.leading, 15)
                            }
                        }
                        .frame(height: 40)
                        
                        Button(action: { if playerCount < 12 { playerCount += 1 } }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(playerCount < 12 ? .white : .gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(20)
                }
                
                // MARK: Start Button
                Button(action: {
                    let initialContext = TelepathyContext(playerCount: playerCount, history: [])
                    navPath.append(GameNavigation.telestrationsTurn(context: initialContext))
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("START CHAIN")
                    }
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [.teal, .purple], startPoint: .leading, endPoint: .trailing))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .shadow(color: .purple.opacity(0.5), radius: 10, y: 5)
                }
                .buttonStyle(BouncyGameButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
}