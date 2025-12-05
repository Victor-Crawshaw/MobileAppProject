// Views/Telestrations/TelestrationsTurnView.swift
import SwiftUI
import PencilKit

struct TelestrationsTurnView: View {
    @Binding var navPath: NavigationPath
    
    // We now use the ViewModel to handle state and logic
    @StateObject private var viewModel: TelestrationsViewModel
    
    @FocusState private var isFocused: Bool
    
    // Custom Init to inject context into the ViewModel
    init(navPath: Binding<NavigationPath>, context: TelepathyContext) {
        self._navPath = navPath
        // Initialize the StateObject with the passed context
        self._viewModel = StateObject(wrappedValue: TelestrationsViewModel(initialContext: context, initialPlayerCount: context.playerCount))
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 15) {
                // --- HEADER ---
                HStack {
                    // Abort Button
                    Button(action: { navPath = NavigationPath() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark.circle.fill")
                            Text("ABORT")
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Player Info
                    Text("PLAYER \(viewModel.context.nextPlayerNumber)")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .padding(8)
                        .background(Color.teal.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Mission Text
                Text(viewModel.missionLabel)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.gray)
                
                // --- THE PROMPT ---
                VStack {
                    if let lastEntry = viewModel.context.history.last {
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
                        Text("CREATE THE SECRET PROMPT")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.purple)
                            .padding(.top)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // --- THE INPUT ---
                if viewModel.isDrawingRound {
                    // === DRAWING MODE ===
                    VStack(spacing: 12) {
                        
                        // 1. Drawing Toolbar
                        HStack(spacing: 15) {
                            
                            // -- Color Picker --
                            // Only visible if not erasing
                            if !viewModel.isEraserActive {
                                ColorPicker("Ink Color", selection: $viewModel.selectedColor)
                                    .labelsHidden()
                                    .padding(8)
                                    .background(Circle().fill(Color.white.opacity(0.1)))
                                    .transition(.scale)
                            }
                            
                            // -- Size Slider --
                            HStack {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 5))
                                Slider(value: $viewModel.strokeWidth, in: 1...30)
                                    .tint(viewModel.isEraserActive ? .pink : viewModel.selectedColor)
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 20))
                            }
                            .foregroundColor(.gray)
                            
                            Spacer()
                            
                            // -- Eraser Toggle --
                            Button(action: {
                                withAnimation(.spring()) {
                                    viewModel.isEraserActive.toggle()
                                }
                            }) {
                                Image(systemName: viewModel.isEraserActive ? "eraser.fill" : "eraser")
                                    .font(.title2)
                                    .foregroundColor(viewModel.isEraserActive ? .pink : .gray)
                                    .padding(8)
                                    .background(viewModel.isEraserActive ? Color.pink.opacity(0.2) : Color.clear)
                                    .clipShape(Circle())
                            }
                            
                            // -- Clear All --
                            Button(action: {
                                viewModel.drawing = PKDrawing()
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
                                drawing: $viewModel.drawing,
                                inkColor: viewModel.selectedColor,
                                inkWidth: viewModel.strokeWidth,
                                isEraser: viewModel.isEraserActive
                            )
                            .onAppear {
                                viewModel.canvasRect = geo.frame(in: .local)
                            }
                            .onChange(of: geo.size) { _, newSize in
                                viewModel.canvasRect = CGRect(origin: .zero, size: newSize)
                            }
                        }
                        .frame(height: 350)
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(viewModel.isEraserActive ? Color.pink : Color.teal, lineWidth: 4)
                        )
                        
                        Text(viewModel.isEraserActive ? "Erasing..." : "Draw with your finger")
                            .font(.caption)
                            .foregroundColor(viewModel.isEraserActive ? .pink : .gray)
                            .animation(.default, value: viewModel.isEraserActive)
                    }
                    .padding(.horizontal)
                    
                } else {
                    // === TEXT GUESS MODE ===
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ENTER YOUR PROMPT")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                        
                        TextField("", text: $viewModel.textInput)
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
                                    if viewModel.textInput.isEmpty {
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
                        Text(viewModel.submitButtonLabel)
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.canSubmit ? Color.teal : Color.gray.opacity(0.3))
                    )
                    .foregroundColor(viewModel.canSubmit ? .white : .white.opacity(0.3))
                    .shadow(color: viewModel.canSubmit ? .teal.opacity(0.5) : .clear, radius: 10, y: 5)
                }
                .disabled(!viewModel.canSubmit)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- LOGIC ---
    
    private func handleDone() {
        if let nextContext = viewModel.submitTurn() {
            if nextContext.isGameOver {
                navPath.append(GameNavigation.telestrationsResult(context: nextContext))
            } else {
                navPath.append(GameNavigation.telestrationsPass(context: nextContext))
            }
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
