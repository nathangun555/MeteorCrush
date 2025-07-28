//
//  ExplosionEffects.swift
//  MeteorCrush
//
//  Created by Livanty Efatania Dendy on 18/07/25.
//

import SpriteKit

struct ExplosionEffects {
    static func playExplosion(at position: CGPoint, in scene: SKScene, completion: @escaping () -> Void) {
        let textureNames = ["explo1", "explo2", "explo3", "explo4", "explo5", "explo6"]
        
        // Menghentikan roket dan meteor jika gameScene terdeteksi
        if let gameScene = scene as? GameScene {
            gameScene.scrollSpeed = 0
            gameScene.rocketFire.node.removeFromParent()
            
            gameScene.children.forEach { node in
                if node.physicsBody?.categoryBitMask == PhysicsCategory.Meteor {
                    node.removeAllActions()
                }
            }
        }
        
        var actions: [SKAction] = []
        
        for (index, name) in textureNames.enumerated() {
            // Penundaan antar ledakan
            let delay = SKAction.wait(forDuration: 0.1)  // Menyesuaikan penundaan antar ledakan
            
            let addExplosion = SKAction.run {
                let texture = SKTexture(imageNamed: name)
                let sprite = SKSpriteNode(texture: texture)
                sprite.position = position
                sprite.zPosition = 999 - CGFloat(index)
                sprite.setScale(0.3)  // Ukuran tetap agar tidak terlalu besar
                scene.addChild(sprite)

                // Efek fadeOut dan penghapusan
                let fade = SKAction.fadeOut(withDuration: 0.3)
                let remove = SKAction.removeFromParent()
                sprite.run(SKAction.sequence([fade, remove]))
            }
            
            actions.append(SKAction.sequence([delay, addExplosion]))
        }
        
        // Menjalankan seluruh efek ledakan dengan urutan yang benar
        let explosionSequence = SKAction.sequence(actions)
        
        // Menjalankan ledakan secara terus-menerus (looping)
        let repeatExplosion = SKAction.repeatForever(explosionSequence)
        // Menjalankan ledakan
        scene.run(repeatExplosion, withKey: "ExplosionAction")
        
        // Game Over setelah 3 detik atau beberapa ledakan
        let gameOverDelay: TimeInterval = 0.5
        scene.run(SKAction.wait(forDuration: gameOverDelay)) {
            // Tampilkan game over tanpa menghentikan ledakan
           
            completion()  // Memanggil completion setelah game over ditampilkan

        }
    }
    
  
}





