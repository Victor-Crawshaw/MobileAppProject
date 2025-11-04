import SwiftUI

struct ConfirmationView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Think of an")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text(category.dropLast(1)) // "Animals" -> "Animal"
                .font(.system(size: 40, weight: .bold, design: .rounded))
                
            Text("Got it? Tap 'Ready' to begin.")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top, 20)
            
            Spacer()
            
            // 1. Changed NavigationLink to a Button
            Button(action: {
                navPath.append(GameNavigation.twentyQuestionsGame(category: category))
            }) {
                Text("I'm Ready")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(navPath: .constant(NavigationPath()), category: "Animals")
    }
}

