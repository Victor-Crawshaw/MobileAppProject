// Views/TwentyQuestions/CategorySelectionView.swift
import SwiftUI

struct CategorySelectionView: View {
    
    @Binding var navPath: NavigationPath
    
    let categories = ["Animals", "Places", "People"]
    
    var body: some View {
        VStack {
            Text("Choose a Category")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            List(categories, id: \.self) { category in
                // MODIFIED: This button's action has changed
                Button(action: {
                    // This now navigates to the NEW SecretInputView
                    navPath.append(GameNavigation.twentyQuestionsSecretInput(category: category))
                }) {
                    HStack {
                        Text(category)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CategorySelectionView(navPath: .constant(NavigationPath()))
    }
}
