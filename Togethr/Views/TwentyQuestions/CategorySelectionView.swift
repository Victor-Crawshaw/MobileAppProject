import SwiftUI

struct CategorySelectionView: View {
    
    @Binding var navPath: NavigationPath
    
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
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                Text("MISSION PARAMETERS")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.teal)
                    .tracking(2)
                    .padding(.top, 20)
                
                Text("Select Category")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .purple, radius: 10)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20)], spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                navPath.append(GameNavigation.twentyQuestionsSecretInput(category: category))
                            }) {
                                VStack(spacing: 10) {
                                    // Extract Emoji
                                    if let emoji = category.split(separator: " ").last {
                                        Text(String(emoji))
                                            .font(.system(size: 50))
                                    }
                                    
                                    // Extract Name
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct CategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectionView(navPath: .constant(NavigationPath()))
    }
}
