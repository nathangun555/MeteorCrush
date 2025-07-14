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
            // remove the exact star that was collided on
            let index = scene.stars.firstIndex(where: {$0 === other.node}) ?? -1
            if(index >= 0){
                scene.stars.remove(at: index)
            }
            let starNewY = scene.size.height * 1 + 100
            ObstacleSpawner.spawnStar(in: scene, atY: starNewY)
            print("Stars now : \(scene.stars.count)")
            
        case PhysicsCategory.Fuel:
            hud.fuel = min(hud.fuel + 20, 100)
            other.node?.removeFromParent()
            let index = scene.fuels.firstIndex(where: {$0 === other.node}) ?? -1
            if(index >= 0){
                scene.fuels.remove(at: index)
            }
            let fuelNewY = scene.size.height * 1 + 200
            ObstacleSpawner.spawnFuel(in: scene, atY: fuelNewY)
            print("Fuels now : \(scene.fuels.count)")
            
        default: break
        }
    }
}
