// Views/Telestrations/TelestrationsTurnView.swift
import SwiftUI
import PencilKit

struct TelestrationsTurnView: View {
    @Binding var navPath: NavigationPath
    @State var context: TelepathyContext
    
    // --- State for Input ---
    @State private var textInput: String = ""
    
    // --- State for Drawing ---
    @State private var drawing = PKDrawing()
    @State private var canvasRect: CGRect = .zero
    
    // Drawing Customization State
    @State private var selectedColor: Color = .black
    @State private var strokeWidth: Double = 5.0
    
    // NEW: Eraser State
    @State private var isEraserActive: Bool = false
    
    @FocusState private var isFocused: Bool
    
    // Determine the current mode based on history
    private var isDrawingRound: Bool {
        guard let last = context.history.last else { return false }
        switch last {
        case .text: return true
        case .drawing: return false
        }
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 20) {
                // --- HEADER ---
                HStack {
                    Text("PLAYER \(context.nextPlayerNumber)")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .padding(8)
                        .background(Color.teal.opacity(0.1))
                        .cornerRadius(8)
                    Spacer()
                    Text(isDrawingRound ? "MISSION: DRAW THIS" : "MISSION: GUESS THIS")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                // --- THE PROMPT ---
                VStack {
                    if let lastEntry = context.history.last {
                        switch lastEntry {
                        case .text(let text):
                            Text(text.uppercased())
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(16)
                            
                        case .drawing(let data):
                            if let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 250)
                                    .background(Color.white) // Drawing needs white bg
                                    .cornerRadius(12)
                            }
                        }
                    } else {
                        Text("CREATE THE SECRET PHRASE")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.purple)
                            .padding(.top)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // --- THE INPUT ---
                if isDrawingRound {
                    // === DRAWING MODE ===
                    VStack(spacing: 12) {
                        
                        // 1. Drawing Toolbar
                        HStack(spacing: 15) {
                            
                            // -- Color Picker --
                            // Only visible if not erasing
                            if !isEraserActive {
                                ColorPicker("Ink Color", selection: $selectedColor)
                                    .labelsHidden()
                                    .padding(8)
                                    .background(Circle().fill(Color.white.opacity(0.1)))
                                    .transition(.scale)
                            }
                            
                            // -- Size Slider --
                            HStack {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 5))
                                Slider(value: $strokeWidth, in: 1...30) // Increased range for eraser
                                    .tint(isEraserActive ? .pink : selectedColor)
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 20))
                            }
                            .foregroundColor(.gray)
                            
                            Spacer()
                            
                            // -- Eraser Toggle --
                            Button(action: {
                                withAnimation(.spring()) {
                                    isEraserActive.toggle()
                                }
                            }) {
                                Image(systemName: isEraserActive ? "eraser.fill" : "eraser")
                                    .font(.title2)
                                    .foregroundColor(isEraserActive ? .pink : .gray)
                                    .padding(8)
                                    .background(isEraserActive ? Color.pink.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())
                            }
                            
                            // -- Clear All --
                            Button(action: {
                                drawing = PKDrawing()
                            }) {
                                Image(systemName: "trash.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                        
                        // 2. The Canvas
                        GeometryReader { geo in
                            DrawingCanvas(
                                drawing: $drawing,
                                inkColor: selectedColor,
                                inkWidth: strokeWidth,
                                isEraser: isEraserActive // Pass eraser state
                            )
                            .onAppear {
                                canvasRect = geo.frame(in: .local)
                            }
                            .onChange(of: geo.size) { _, newSize in
                                canvasRect = CGRect(origin: .zero, size: newSize)
                            }
                        }
                        .frame(height: 350)
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isEraserActive ? Color.pink : Color.teal, lineWidth: 4)
                        )
                        
                        Text(isEraserActive ? "Erasing..." : "Draw with your finger")
                            .font(.caption)
                            .foregroundColor(isEraserActive ? .pink : .gray)
                            .animation(.default, value: isEraserActive)
                    }
                    .padding(.horizontal)
                    
                } else {
                    // === TEXT GUESS MODE ===
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ENTER YOUR GUESS")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                        
                        TextField("", text: $textInput)
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isFocused ? Color.teal : Color.clear, lineWidth: 2)
                            )
                            .focused($isFocused)
                            .submitLabel(.done)
                            .overlay(
                                HStack {
                                    if textInput.isEmpty {
                                        Text("e.g. Alien Spaceship")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .padding(.leading, 16)
                                    }
                                    Spacer()
                                }
                                .allowsHitTesting(false)
                            )
                    }
                    .padding(.horizontal, 40)
                    .onAppear { isFocused = true }
                }
                
                Spacer()
                
                // --- DONE BUTTON ---
                Button(action: handleDone) {
                    HStack {
                        Text(context.history.count + 1 == context.playerCount ? "FINISH GAME" : "LOCK IN & PASS")
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(canSubmit ? Color.teal : Color.gray.opacity(0.3))
                    )
                    .foregroundColor(canSubmit ? .white : .white.opacity(0.3))
                    .shadow(color: canSubmit ? .teal.opacity(0.5) : .clear, radius: 10, y: 5)
                }
                .disabled(!canSubmit)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- LOGIC ---
    
    private var canSubmit: Bool {
        if isDrawingRound {
            return !drawing.bounds.isEmpty
        } else {
            return !textInput.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
    private func handleDone() {
        var nextHistory = context.history
        
        if isDrawingRound {
            // Safeguard for rect
            var captureRect = canvasRect
            if captureRect.width <= 0 || captureRect.height <= 0 {
                 captureRect = drawing.bounds.insetBy(dx: -20, dy: -20)
            }
            if captureRect.width <= 0 { captureRect = CGRect(x: 0, y: 0, width: 300, height: 350) }

            // Generate Image
            let image = drawing.image(from: captureRect, scale: 1.0)
            
            if let pngData = image.pngData() {
                nextHistory.append(.drawing(pngData))
            }
        } else {
            nextHistory.append(.text(textInput))
        }
        
        var nextContext = context
        nextContext.history = nextHistory
        
        if nextContext.isGameOver {
             navPath.append(GameNavigation.telestrationsResult(context: nextContext))
        } else {
             navPath.append(GameNavigation.telestrationsPass(context: nextContext))
        }
    }
}

// --- UPDATED PENCILKIT WRAPPER ---
struct DrawingCanvas: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    
    var inkColor: Color
    var inkWidth: Double
    var isEraser: Bool // New Property

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        
        // 1. Force Light Mode so standard colors render correctly
        canvas.overrideUserInterfaceStyle = .light
        
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.delegate = context.coordinator
        
        canvas.drawing = drawing
        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
        // 2. TOGGLE BETWEEN INK AND ERASER
        if isEraser {
            // Bitmap eraser allows erasing parts of strokes
            uiView.tool = PKEraserTool(.bitmap, width: CGFloat(inkWidth))
        } else {
            // 3. THE FIX FOR INVISIBLE BLACK INK
            // We strip the "Adaptive" nature of the color.
            // "System Black" changes based on Dark Mode.
            // "Resolved Black" is always RGB(0,0,0).
            let dynamicColor = UIColor(inkColor)
            let fixedColor = dynamicColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            
            uiView.tool = PKInkingTool(.marker, color: fixedColor, width: CGFloat(inkWidth))
        }

        // Standard Sync
        if uiView.drawing != drawing {
            uiView.drawing = drawing
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: DrawingCanvas
        
        init(_ parent: DrawingCanvas) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.parent.drawing = canvasView.drawing
            }
        }
    }
}