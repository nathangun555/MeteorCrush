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
        startSpawning(after: 2)
    }

    private func startSpawning(after delay: TimeInterval) {
        startTime = CACurrentMediaTime()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.scheduleMeteorSpawning()
        }
    }

    private func scheduleMeteorSpawning() {
        spawnTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 3...5), repeats: true) { [weak self] _ in
            guard let self = self, let gameScene = self.scene as? GameScene else { return }
            if gameScene.isGameOver { return } // ⛔ stop spawn
            SoundManager.shared.playSFX(named: "incomingMeteor", withExtension: "wav")
            self.spawnMeteor()
        }
    }
    private func spawnMeteor() {
        let textures = ["FallingMeteor1.1", "FallingMeteor1.2", "FallingMeteor1.3"].map { SKTexture(imageNamed: $0) }
        
        let meteor = SKSpriteNode(texture: textures[0])
        meteor.size = CGSize(width: 40, height: 250)
        meteor.zPosition = 1

        meteor.color = .red
        meteor.colorBlendFactor = 0.0
        meteor.alpha = 1

        // Physics
        let ballRadius: CGFloat = 13
        let offsetY = -meteor.size.height / 2 + ballRadius + 5

        meteor.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius, center: CGPoint(x: 0, y: offsetY))
        meteor.physicsBody?.categoryBitMask = PhysicsCategory.Meteor
        meteor.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        meteor.physicsBody?.collisionBitMask = PhysicsCategory.None
        meteor.physicsBody?.affectedByGravity = false
        meteor.physicsBody?.isDynamic = false

        // Debug visual lingkaran hijau
        let debugCircle = SKShapeNode(circleOfRadius: ballRadius)
        debugCircle.strokeColor = .green
        debugCircle.lineWidth = 2
        debugCircle.position = CGPoint(x: 0, y: offsetY)
        debugCircle.zPosition = -1
        meteor.addChild(debugCircle)


        // 1. Start (top of screen)
        let startX = CGFloat.random(in: 0...scene.size.width)
        let startY = scene.size.height + meteor.size.height
        meteor.position = CGPoint(x: startX, y: startY)

        // 2. Target (bottom of screen)
        let targetX = CGFloat.random(in: 0...scene.size.width)
        let targetY: CGFloat = -meteor.size.height

        // 3. Face toward target
        let dx = targetX - startX
        let dy = targetY - startY
        let angle = atan2(dy, dx)
        meteor.zRotation = angle + .pi / 2

        // 4. Add to scene
        scene.addChild(meteor)

        // 5. Animate + move
        let anim = SKAction.animate(with: textures, timePerFrame: 0.1)
        meteor.run(SKAction.repeatForever(anim), withKey: "meteorAnim")

        let move = SKAction.move(to: CGPoint(x: targetX, y: targetY), duration: 2)
        let remove = SKAction.removeFromParent()
        meteor.run(SKAction.sequence([move, remove]), withKey: "falling")

        print("[MeteorSpawner] Meteor falling from (\(Int(startX)),\(Int(startY))) → (\(Int(targetX)),\(Int(targetY)))")
    }


    func stopSpawning() {
        print("stop")
        spawnTimer?.invalidate()
        spawnTimer = nil
    }
}
