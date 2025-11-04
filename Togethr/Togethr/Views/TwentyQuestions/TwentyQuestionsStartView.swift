import SwiftUI

struct TwentyQuestionsStartView: View {
    
    // 1. We still need the path to pass it along
    @Binding var navPath: NavigationPath
    
    @State private var showingHowToPlay = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("20 Questions")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            
            Spacer()
            
            // 2. This is now a Button that appends to the path
            Button(action: {
                navPath.append(GameNavigation.twentyQuestionsCategory)
            }) {
                Text("Start Game")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
            
            Button(action: {
                showingHowToPlay = true
            }) {
                Text("How to Play")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.clear)
                    .foregroundColor(.blue)
                    .font(.headline)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("")
        .navigationBarHidden(true)
        .sheet(isPresented: $showingHowToPlay) {
            HowToPlayView()
        }
    }
}

struct TwentyQuestionsStartView_Previews: PreviewProvider {
    static var previews: some View {
        TwentyQuestionsStartView(navPath: .constant(NavigationPath()))
    }
}

