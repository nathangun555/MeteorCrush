//
//  CollisionHandler.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//


import SpriteKit

struct CollisionHandler {
    let scene: GameScene
    let hud: HUD
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
            starScoring(scene.rocket.color, .red)
            other.node?.removeFromParent()
            hud.starCount = scene.stars.count
        case PhysicsCategory.blueStar:
            starScoring(scene.rocket.color, .blue)
            other.node?.removeFromParent()
            hud.starCount = scene.stars.count
        case PhysicsCategory.greenStar:
            starScoring(scene.rocket.color, .green)
            other.node?.removeFromParent()
            hud.starCount = scene.stars.count
        case PhysicsCategory.Fuel:
            hud.fuel = min(hud.fuel + 20, 100)
            other.node?.removeFromParent()
        case PhysicsCategory.redGate:
            scene.rocket.texture = SKTexture(imageNamed: "rocketPink")
            scene.rocket.colorBlendFactor = 0
            print("lewat pink")        
        case PhysicsCategory.greenGate:
            scene.rocket.texture = SKTexture(imageNamed: "rocketGreen")
            scene.rocket.colorBlendFactor = 0
            print("lewat hijau")
        case PhysicsCategory.blueGate:
            scene.rocket.texture = SKTexture(imageNamed: "rocketBlue")
            scene.rocket.colorBlendFactor = 0
            print("lewat biru")
        default: break
        }
        
        func starScoring(_ rocketColor: UIColor, _ starColor: UIColor){
            if (rocketColor == .red && starColor == .red) || (rocketColor == .green && starColor == .green) || (rocketColor == .blue && starColor == .blue)
            {
                hud.score += 5
            } else
            {
                hud.score -= 1
            }
        }
    }
}
