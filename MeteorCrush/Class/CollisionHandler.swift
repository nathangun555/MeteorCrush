//
//  CollisionHandler.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//


import SpriteKit

struct CollisionHandler {
    let scene: GameScene
    static func handle(_ contact: SKPhysicsContact, in scene: GameScene, hud: HUD) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Rocket ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
        case PhysicsCategory.Planet:
            scene.isGameOver = true
//            scene.rocket.removeFromParent()
            let gameOver = SKLabelNode(fontNamed: "AvenirNext-Bold")
            gameOver.text = "Game Over"; gameOver.fontSize = 48
            gameOver.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
            scene.addChild(gameOver)
        case PhysicsCategory.Star:
            hud.score += 5
            other.node?.removeFromParent()
            
            hud.starCount = scene.stars.count
//            ObstacleSpawner.spawnStar(in: scene, atY: <#T##CGFloat#>)
        case PhysicsCategory.Fuel:
            hud.fuel = min(hud.fuel + 20, 100)
            other.node?.removeFromParent()
        default: break
        }
    }
}
