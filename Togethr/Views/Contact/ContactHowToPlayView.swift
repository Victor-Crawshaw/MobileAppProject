// Views/Contact/ContactHowToPlayView.swift
import SwiftUI

struct ContactHowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("How to Play: Contact")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .padding(.horizontal)

            // ScrollView to contain all the rules
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("One person thinks of any word and all other people must work together to guess what that word is through giving clues to other words. The guy giving the word the **defender**. The defender gives out the first letter of his word. For example, lets say the secret word is \"duck.\" The letter \"D\" would then be announced to everyone. Now, everyone else must secretly come up with their own word that starts with the given letter and announce a clue pertaining to that word. The goal of this clue is stump the defender but hopefully get someone else to know what is being referred to. When a clue is announced and another person thinks they know what word is being referenced, they declare **\"contact\"** with the clue giver. When this is declared, the defender is now forced to guess by himself what the word is. If he can not, he declares **\"challenge\"** in which case the people that have declared contact counts to three and shouts what word they think it is. If the words match, the defender reveals the next letter in the word. If the words do not match or the defender successfully guesses the correct word, the clue becomes void and nothing happens.")
                    
                    // Example Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Example:")
                            .font(.headline)
                        
                        Text("Defender's secret word is **duck**, the letter **D** is given.")
                        Text("Someone announces the clue \"A type of flower.\" (referring to the word **daffodil**)")
                        Text("Someone else thinks they know what is being referred to and declares a contact.")
                        Text("The defender must now try to guess what it is. He gets as many tries and as long as he wants, restrained by common courtesy expectations. If he succeeds, the clue is void and nothing happens. If he gives up, he declares a **challenge**. Daisy? Nope. Dandelion? Nope. Ok, I give up, challenge!")
                        Text("When challenge is declared, the announcer of the clue and the people in contact count to three and shout the word they are thinking. If they don't match they fail and nothing happens. If they do, (both shout **daffodil**) the defender must now reveal the next letter.")
                        Text("The letters **\"Du\"** is now given. All clues must now refer to words beginning with these letters. The same process is repeated with an extra letter given each time the defender gives up and a successful contact is done.")
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Bullet Points
                    VStack(alignment: .leading, spacing: 15) {
                        Text("• Anybody at anytime may give a clue when they think of one, there are no turns.")
                        Text("• No word can be used more than once for a clue.")
                        Text("• Any number of people may declare contact, as long as one person successfully matches the word of the original clue, the defender must give up a letter.")
                        Text("• When challenge is declared, no other contacts may be made. Therefore, it can be beneficial for the defender to declare an early challenge so that additional people won't have any time to make contact, decreasing the chance for a matching word. This is especially important when really vague clues are given and the defender doubts that the other people are thinking of the same word.")
                        Text("• A winner is declared when someone gives a clue to the defender's word and is revealed through a challenge. The winner becomes the new defender for the next round. For example, The defender's word is \"duck,\" a clue is given \"an animal that waddles.\" Someone contacts. Since the defender is pretty sure the clue is referring to his word, he is forced to declare challenge. Even if the contacted person doesn't have the same word, as long as the clue giver says duck, he wins. However, if no one contacts the clue, then the word can't be revealed, and the status quo is maintained.")
                        Text("• Clues are not static, if one is given out and no one has contact, the clue giver may add to it as much as he wants, or drop it.")
                    }
                    
                }
                .padding(.horizontal, 30) // Horizontal padding for the text
                .padding(.bottom, 20) // Padding at the very bottom
            }

            // "Got It!" button sticks to the bottom
            Button(action: {
                dismiss() // Close the sheet
            }) {
                Text("Got It!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .background(.bar) // Helps button stand out from scroll view
        }
    }
}

struct ContactHowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        ContactHowToPlayView()
    }
}