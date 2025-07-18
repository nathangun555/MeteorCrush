//
//  FallingMeteorSpawner.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 16/07/25.
//


import SpriteKit

class FallingMeteorSpawner {
    private var scene: SKScene
    private var spawnTimer: Timer?
    private var startTime: TimeInterval = 0

    init(scene: SKScene) {
        self.scene = scene
        startSpawning(after: 10)
    }

    private func startSpawning(after delay: TimeInterval) {
        startTime = CACurrentMediaTime()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.scheduleMeteorSpawning()
        }
    }

    private func scheduleMeteorSpawning() {
        spawnTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 3...5), repeats: true) { [weak self] _ in
            self?.spawnMeteor()
        }
    }

    private func spawnMeteor() {
        guard let scene = scene as? SKScene else { return }

        let textures = ["FallingMeteor1.1", "FallingMeteor1.2", "FallingMeteor1.3"].map { SKTexture(imageNamed: $0) }
        let meteor = SKSpriteNode(texture: textures[0])
        meteor.size = CGSize(width: 60, height: 140)
        meteor.zPosition = 15

        // Start from random X off the left or right edge
        let fromLeft = Bool.random()
        let startX = fromLeft ? -meteor.size.width : scene.size.width + meteor.size.width
        let startY = scene.size.height + meteor.size.height
        meteor.position = CGPoint(x: startX, y: startY)

        scene.addChild(meteor)

        let anim = SKAction.animate(with: textures, timePerFrame: 0.1)
        let repeatAnim = SKAction.repeatForever(anim)
        meteor.run(repeatAnim, withKey: "meteorAnim")

        // Diagonal fall: down + left or right
        let dx: CGFloat = fromLeft ? 1 : -1
        let fall = SKAction.moveBy(x: dx * -scene.size.width * 1.2, y: -scene.size.height * 1.5, duration: 4.0)
        let remove = SKAction.removeFromParent()
        meteor.run(SKAction.sequence([fall, remove]), withKey: "falling")
    }

    func stopSpawning() {
        spawnTimer?.invalidate()
        spawnTimer = nil
    }
}
