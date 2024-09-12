//
//  ContentView.swift
//  ScratchCard_Demo_View
//
//  Created by vignesh kumar c on 12/09/24.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var lineWidth: Double = 50.0
}

struct ContentView: View {
    @State private var currentLine = Line()
    @State private var lines = [Line]()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.red)
                .frame(width: 250, height: 250)
            RoundedRectangle(cornerRadius: 20)
                .fill(.yellow)
                .frame(width: 250, height: 250)
                .mask( Canvas { context, _ in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                    
                })
                .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .local).onChanged({ newValue in
                    let newPoint = newValue.location
                    currentLine.points.append(newPoint)
                    lines.append(currentLine)
                }))
            
        }  
    }
}

#Preview {
    ContentView()
}
