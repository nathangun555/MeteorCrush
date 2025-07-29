//
//  GameViewModel.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 29/07/25.
//

import Foundation
import SwiftUI

@Observable
class GameViewModel {
    let scene: GameScene
    
    init() {
        scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
    }
}
