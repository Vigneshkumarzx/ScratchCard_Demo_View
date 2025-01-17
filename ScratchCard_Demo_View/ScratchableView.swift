//
//  ScratchableView.swift
//  ScratchCard_Demo_View
//
//  Created by vignesh kumar c on 12/09/24.
//

import SwiftUI

struct ScratchableView: View {
    @State private var points = [CGPoint]()
    @State private var selection: Int = 0
    @State private var topShine = true
    @State private var enableTopShine = false
    @State private var clearScratchArea = false
    @StateObject private var motionManager = MotionManager()
    private let gridSize = 5
    private let gridCellSize = 50

    private let scratchClearAmount: CGFloat = 0.5
    private let pokemon: [[String: Any]] = [
        ["name":"diamontHead", "color": Color.yellow],
        ["name":"fourarms", "color": Color.mint],
        ["name":"grayMatter", "color": Color.green],
        ["name":"omni", "color": Color.green],
        ["name":"ripjaws", "color": Color.cyan],
        ["name":"wildmut", "color": Color.orange],
        ["name":"wildwine", "color": Color.green],
        ["name":"xlr8", "color": Color.blue],
    ]
    
    var body: some View {
        VStack {
           /* Image("ben10Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150) */

            ZStack {
                // MARK: Scratchable TOP view
                RoundedRectangle(cornerRadius: 20)
                    .fill(.red)
                    .frame(width: 250, height: 250)
                    .overlay {
                        Image("ben10Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                    }
                    .animation(.easeInOut, value: clearScratchArea)
                    .shimmer(shine: $topShine, stopShine: $enableTopShine)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .compositingGroup()
                    .shadow(color: .black, radius: 5)
                    .opacity(clearScratchArea ? 0 : 1)
                    .id(enableTopShine)
                    .onAppear(perform: {
                        topShine.toggle()
                    })
                RoundedRectangle(cornerRadius: 20)
                    .fill(pokemon[selection]["color"] as? Color ?? .white)
                    .frame(width: 250, height: 250)
                    .overlay {
                        Image(pokemon[selection]["name"] as? String ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                    }
                    .compositingGroup()
                    .shadow(color: .black, radius: 5)
                    .opacity(clearScratchArea ? 1 : 0)
                    .rotation3DEffect(.degrees(motionManager.x * 10), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(motionManager.y * 10), axis: (x: -1, y: 0, z: 0))
                RoundedRectangle(cornerRadius: 20)
                    .fill(pokemon[selection]["color"] as? Color ?? .white)
                    .frame(width: 250, height: 250)
                    .overlay {
                        Image(pokemon[selection]["name"] as? String ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                    }
                    .mask(
                        Path { path in
                            path.addLines(points)
                        }.stroke(style: StrokeStyle(lineWidth: 50, lineCap: .round, lineJoin: .round))
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ value in
                                points.append(value.location)
                                let feedbackGen = UIImpactFeedbackGenerator(style: .soft)
                                feedbackGen.impactOccurred()
                                if !enableTopShine {
                                    enableTopShine.toggle()
                                    topShine.toggle()
                                }
                            })
                            .onEnded { _ in
                                // Create a CGPath from the drawn points
                                let cgpath = Path { path in
                                    path.addLines(points)
                                }.cgPath
                                
                                // Thicken the path to match the stroke width
                                let thickenedPath = cgpath.copy(strokingWithWidth: 50, lineCap: .round, lineJoin: .round, miterLimit: 10)
                                
                                var scratchedCount = 0
                                
                                // Check if each grid cell's center point is within the thickened path
                                for i in 0..<gridSize {
                                    for j in 0..<gridSize {
                                        let point = CGPoint(x: gridCellSize / 2 + i * gridCellSize, y: gridCellSize / 2 + j * gridCellSize)
                                        if thickenedPath.contains(point) {
                                            scratchedCount += 1
                                        }
                                    }
                                }

                                // Calculate the percentage of scratched cells
                                let scratchedPercentage = Double(scratchedCount) / Double(gridSize * gridSize)

                                // If scratched area exceeds the threshold, clear the top view
                                if scratchedPercentage > scratchClearAmount {
                                    clearScratchArea = true
                                    motionManager.isActive = true
                                }
                            }
                    )
                    .opacity(clearScratchArea ? 0 : 1)
            }

            Button(action: {
                selection = (selection + 1) % pokemon.count
            }, label: {
                Text("Catch")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(width: 220)
                    .padding(.vertical, 8)
            })
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .overlay {
                Capsule().stroke(Color.white, lineWidth: 5.0)
                    .padding(3)
                    .overlay {
                        Capsule().stroke(Color.black, lineWidth: 5.0)
                    }
            }
            .clipShape(Capsule())
            .padding(.vertical, 20)
        }
        .onChange(of: selection, perform: { value in
            motionManager.isActive = false
            points = []
            clearScratchArea = false
            enableTopShine.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                topShine.toggle()
            }
        })
    }
}

#Preview {
    ScratchableView()
}


struct ShimmerModifier: ViewModifier {
    var repeatCount: Int? = nil
    var duration: Double
    
    @Binding var shine: Bool
    @Binding var stopShine: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(colors: [.clear, .white.opacity(0.8), .clear], startPoint: .leading, endPoint: .trailing)
                    .frame(width: 100)
                    .offset(x: shine ? -250 : 250)
                    .rotationEffect(.degrees(-45))
                    .scaleEffect(2)
                    .animation(stopShine ? .none :
                        repeatCount != nil ?
                            .linear(duration: duration).repeatCount(repeatCount!, autoreverses: false) :
                                .linear(duration: duration).repeatForever(autoreverses: false),
                        value: stopShine ? false : shine
                    )
            )
    }
}

extension View {
    func shimmer(repeatCount: Int? = nil, duration: Double = 3.0, shine: Binding<Bool>, stopShine: Binding<Bool>) -> some View {
        self.modifier(ShimmerModifier(repeatCount: repeatCount, duration: duration, shine: shine, stopShine: stopShine))
    }
}
