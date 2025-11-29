// Views/Telestrations/TelestrationsResultView.swift
import SwiftUI

struct TelestrationsResultView: View {
    
    @Binding var navPath: NavigationPath
    let context: TelepathyContext
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("THE TIMELINE")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(context.history.enumerated()), id: \.offset) { index, entry in
                            
                            // Connector Line (if not first)
                            if index > 0 {
                                Rectangle()
                                    .fill(LinearGradient(colors: [.purple, .teal], startPoint: .top, endPoint: .bottom))
                                    .frame(width: 4, height: 30)
                            }
                            
                            // Card
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.teal)
                                        .frame(width: 30, height: 30)
                                    Text("\(index + 1)")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.black)
                                }
                                .offset(x: 15)
                                .zIndex(1)
                                
                                VStack {
                                    switch entry {
                                    case .text(let text):
                                        Text(text)
                                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding(20)
                                            .background(Color.white.opacity(0.1))
                                            .cornerRadius(12)
                                        
                                    case .drawing(let data):
                                        if let image = UIImage(data: data) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxHeight: 200)
                                                .frame(maxWidth: .infinity)
                                                .background(Color.white)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding(.leading, 10) // Make room for the number badge
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100)
                }
                
                // Footer
                VStack {
                    Button(action: {
                        navPath = NavigationPath() // Reset to Root
                    }) {
                        Text("RETURN TO MENU")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.4), radius: 10)
                    }
                    .buttonStyle(BouncyGameButtonStyle())
                }
                .padding(20)
                .background(Color(red: 0.05, green: 0.0, blue: 0.15).opacity(0.9))
            }
        }
        .navigationBarHidden(true)
    }
}