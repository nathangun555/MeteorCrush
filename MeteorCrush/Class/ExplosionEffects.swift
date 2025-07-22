//
//  ExplosionEffects.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 18/07/25.
//


import SpriteKit

struct ExplosionEffects {
    static func playExplosion(at position: CGPoint, in scene: SKScene, completion: @escaping () -> Void) {
        let textureNames = ["explo1", "explo2", "explo3", "explo4", "explo5"]
        if let gameScene = scene as? GameScene {
            gameScene.scrollSpeed = 0
            gameScene.rocketFire.node.removeFromParent()
            
            gameScene.children.forEach { node in
                   if node.physicsBody?.categoryBitMask == PhysicsCategory.Meteor {
                       node.removeAllActions() // atau node.isPaused = true
                   }
               }

        }
        
        for (index, name) in textureNames.enumerated() {
            let delay = SKAction.wait(forDuration: Double(index) * 0.1)
            let addExplosion = SKAction.run {
                let texture = SKTexture(imageNamed: name)
                let sprite = SKSpriteNode(texture: texture)
                sprite.position = position
                sprite.zPosition = 999 - CGFloat(index)
                sprite.setScale(0.04)
                sprite.alpha = 1.0 - CGFloat(index) * 0.1
                scene.addChild(sprite)

                let fade = SKAction.fadeOut(withDuration: 0.6)
                let wait = SKAction.wait(forDuration: 0.6)
                let remove = SKAction.removeFromParent()
                sprite.run(SKAction.sequence([wait, fade, remove]))
            }
            scene.run(SKAction.sequence([delay, addExplosion]))
        }

        // Jalankan completion setelah efek terakhir muncul
        let lastExplosionDelay = Double(textureNames.count - 1) * 0.1
        let buffer: TimeInterval = 0.3
        let totalDelay = lastExplosionDelay + buffer
        scene.run(SKAction.sequence([
            SKAction.wait(forDuration: totalDelay),
            SKAction.run(completion)
        ]))
    }
}

