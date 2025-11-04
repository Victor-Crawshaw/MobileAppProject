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
            
            // 1. The List no longer uses NavigationLink
            List(categories, id: \.self) { category in
                // 2. Use a Button to append the next destination
                Button(action: {
                    navPath.append(GameNavigation.twentyQuestionsConfirm(category: category))
                }) {
                    HStack {
                        Text(category)
                            .font(.headline)
                            .foregroundColor(.primary) // Make text look normal
                        Spacer()
                        Image(systemName: "chevron.right") // Add manual chevron
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

