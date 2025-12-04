import SwiftUI

struct CategorySelectionView: View {
    
    @Binding var navPath: NavigationPath
    
    // Pre-defined list of categories with Emojis
    let categories = [
        "Animals 🦁",
        "Food 🍔",
        "Famous People 👩‍🎤",
        "Movies & TV 🎬",
        "Objects 📦",
        "Places 🌍"
    ]

    var body: some View {
        ZStack {
            // Background Color
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 20) {
                // MARK: Navigation Header
                HStack {
                    Button(action: {
                        // Go back to Start View by resetting the path completely
                        navPath = NavigationPath()
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

                // MARK: Page Title
                VStack(spacing: 5) {
                    Text("MISSION PARAMETERS")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(2)
                    
                    Text("Select Category")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .purple, radius: 10)
                }

                // MARK: Category Grid
                ScrollView {
                    // Adaptive grid layout
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20)], spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                // Navigate to Input View with selected category
                                navPath.append(GameNavigation.twentyQuestionsSecretInput(category: category))
                            }) {
                                VStack(spacing: 10) {
                                    // Parse string to separate Emoji from Text
                                    if let emoji = category.split(separator: " ").last {
                                        Text(String(emoji))
                                            .font(.system(size: 50))
                                    }
                                    
                                    // Extract Name (remove emoji + space)
                                    Text(category.dropLast(2))
                                        .font(.system(size: 16, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(red: 0.1, green: 0.1, blue: 0.12))
                                )
                                .overlay(
                                    // Gradient Border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(LinearGradient(colors: [.teal.opacity(0.5), .purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                                )
                                .shadow(color: .black.opacity(0.4), radius: 5, y: 5)
                            }
                            .buttonStyle(BouncyScaleButtonStyle())
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
