# Togethr

**CMU 67443 Mobile Application Design and Development**

**Togethr** is an iOS social gaming platform built entirely in SwiftUI. It serves as a central hub for classic party games, designed to facilitate interaction through multiple modes including In-Person, Online, and Pass & Play. The app features a high-fidelity "gaming" aesthetic with robust navigation architectures and custom tactile interactions.

## Features & Games

Togethr currently supports four distinct games, orchestrated by a centralized navigation system.

### 🎮 20 Questions
A modern take on the classic guessing game, fully implemented with the following flow:
* **Category Selection:** Players choose from presets like *Animals 🦁*, *Food 🍔*, or *Famous People 👩‍🎤*.
* **Secret Input:** The "Knower" locks in a secret word using a secure input view that hides the text from "Guessers."
* **Speech Integration:** The main `GameView` utilizes **SFSpeechRecognizer** to allow guessers to speak their questions, which are automatically transcribed into the game log.
* **Live Game Log:** A scrollable history of `RecordedQuestion`s tracks the game state, allowing players to review previous "Yes/No" answers.
* **Victory States:** The game concludes with a `ResultView` that dramatically reveals the secret word and the winner (Guessers vs. The Secret Keeper).

### ☠️ Hangman
A high-stakes version of the classic word puzzle, featuring a "Deep Space" aesthetic with Orange & Red ambient lighting.
* **Setup Phase:** The "Chooser" inputs a secret word which is automatically sanitized (trimmed and uppercased) and validated to ensure it meets the minimum length requirements.
* **Programmatic Visuals:** Unlike traditional apps that use static images, the Hangman figure is drawn entirely in SwiftUI code. The `HangmanGameView` dynamically renders the gallows and body parts (Head, Body, Arms, Legs) using `RoundedRectangle` and `Circle` shapes with precise `rotationEffect`s based on the number of incorrect guesses.
* **The 6-Life System:** Players have exactly 6 lives. The game visualizes progress by adding one body part per mistake
* **Hand-Off Protocol:** Includes a `ConfirmationView` ("Hand Off Device") with animated iconography to ensure the Guesser doesn't see the secret word before the game begins.
* **End Game:** Displays a dramatic "SURVIVED" (Green) or "ELIMINATED" (Red) screen, revealing the secret word and the number of remaining lives.

### 🛡️ Contact
A high-stakes word deduction game focusing on speed and defense.
* **Setup Phase:** The Defender sets a secret word (e.g., "ASTEROID") and reveals only the first letter ('A').
* **Tactical Timer:** The game supports optional time limits (`TimeInterval?`) to increase pressure on the Guessers. The background glow shifts from blue to red as time runs out.
* **Game Logic:**
    * **Defended:** If the timer expires or the Defender successfully identifies a "Contact" clue before the guessers do, the secret remains safe.
    * **Victory:** Guessers win by deducing the full word or forcing the Defender to reveal letters.
* **Interactive HUD:** Features a "Give Up" option for when the Guessers are stumped, triggering a `ContactResultView` with the specific end-game reason.

### 🎨 Telepathy (Telestrations)
A collaborative "Pass & Play" creativity game where a phrase evolves (or devolves) as it passes between players.
* **State Management:** Uses a `TelepathyContext` object to persist the game history across multiple view transitions (Start -> Turn -> Pass -> Turn -> Result).
* **PencilKit Integration:** The `TelestrationsTurnView` embeds a `PKCanvasView` (via `UIViewRepresentable`), allowing players to draw with a marker tool or erase using a bitmap eraser.
* **Dynamic Flow:** The game alternates between "Draw this phrase" and "Guess this drawing" turns.
* **The Timeline:** At the end of the chain, the `TelestrationsResultView` displays a scrollable visual history showing how the original concept mutated over time.

## Tech Stack

* **Language:** Swift 5
* **Framework:** SwiftUI & PencilKit
* **Architecture:** MVVM (Model-View-ViewModel)
* **Navigation:** `NavigationStack` with type-safe `NavigationPath`
* **Hardware Integration:**
    * `Speech` Framework (SFSpeechRecognizer) for voice input
    * `PencilKit` for touch-based drawing
* **Concurrency:** Async/Await
* **Platform:** iOS 16.0+

## Installation and Setup

To set up the app locally for development or testing:

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/YourUsername/Togethr.git](https://github.com/YourUsername/Togethr.git)
    cd Togethr
    ```

2.  **Open in Xcode**
    * Navigate to the project directory.
    * Open `Togethr.xcodeproj`.

3.  **Permissions**
    * The app uses the Microphone and Speech Recognition. When running the **20 Questions** game for the first time, you must accept the iOS permission prompts for these features to work.

4.  **Build and Run**
    * Select your target simulator (iPhone 14 Pro or later recommended) or a physical device.
    * Press `Cmd + R` to build and run.

## Design Decisions

The UI/UX of Togethr was built to feel immersive and playful, moving away from standard iOS system components.

* **Centralized Type-Safe Navigation:**
    We implemented a global `GameNavigation` enum. This allows the `NavigationStack` in `MainMenuView` to handle all routing logic in a single switch statement, managing complex flows like the multi-stage setup of 20 Questions, the cyclic nature of Telepathy, and the safety barriers in Hangman.

* **Immersive "Gamer" Aesthetic:**
    * **Dark Mode Enforcement:** The app enforces a dark color scheme for a sleek look.
    * **Ambient Lighting:** Custom `ZStack` backgrounds use blurred, high-radius Circles (Teal/Purple for general, Orange/Red for Hangman) to create a "glowing orb" effect.
    * **Custom Typography:** Headers use `design: .rounded` and `design: .monospaced` to differentiate between playful titles and game data.

* **Tactile Feedback:**
    Custom `BouncyGameButtonStyle` and `BouncyScaleButtonStyle` provide spring-based animation feedback on touches (`dampingFraction: 0.6`), making the interface feel responsive and game-like.

