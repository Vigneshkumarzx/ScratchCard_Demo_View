//
//  circleCompostingView.swift
//  ScratchCard_Demo_View
//
//  Created by vignesh kumar c on 12/09/24.
//

import SwiftUI

struct ContentViewOne: View {
    let circles: some View = ZStack {
        Circle()
            .frame(width: 100, height: 100)
            .foregroundColor(.red)
            .offset(y: -25)
        
        Circle()
            .frame(width: 100, height: 100)
            .foregroundColor(.blue)
            .offset(x: -25, y: 25)
        
        Circle()
            .frame(width: 100, height: 100)
            .foregroundColor(.green)
            .offset(x: 25, y: 25)
    }
    
    var body: some View {
        VStack(spacing: 100) {
            circles
            
            circles
                .opacity(0.5)
            
            circles
                .compositingGroup()
                .opacity(0.5)
        }
    }
}

#Preview {
    ContentViewOne()
}

