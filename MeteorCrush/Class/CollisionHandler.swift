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
            scene.rocket.removeFromParent()
            let gameOver = SKLabelNode(fontNamed: "AvenirNext-Bold")
            gameOver.text = "Game Over"; gameOver.fontSize = 48
            gameOver.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
            scene.addChild(gameOver)
        case PhysicsCategory.redStar:
            hud.score += 1
            other.node?.removeFromParent()
            hud.starCount = scene.stars.count
        case PhysicsCategory.blueStar:
            hud.score += 2
            other.node?.removeFromParent()
            hud.starCount = scene.stars.count
        case PhysicsCategory.greenStar:
            hud.score += 3
            other.node?.removeFromParent()
            hud.starCount = scene.stars.count
//            ObstacleSpawner.spawnStar(in: scene, atY: <#T##CGFloat#>)
        case PhysicsCategory.Fuel:
            hud.fuel = min(hud.fuel + 20, 100)
            other.node?.removeFromParent()
        case PhysicsCategory.redGate:
            scene.changeRocketColor(.red)
            print("lewat merah")
        case PhysicsCategory.greenGate:
            scene.changeRocketColor(.green)
            print("lewat hijau")
        case PhysicsCategory.blueGate:
            scene.changeRocketColor(.blue)
            print("lewat biru")
        default: break
        }
    }
}
