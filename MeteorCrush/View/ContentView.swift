//
//  ContentView.swift
//  MeteorCrush
//
//  Created by Nathan Gunawan on 10/07/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    // Buat instance scene-mu
    private var scene: SKScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        // SpriteView adalah representasi SwiftUI untuk SKView
        SpriteView(scene: scene)
            .ignoresSafeArea()   // biar full-screen
    }
}


#Preview {
    ContentView()
}
