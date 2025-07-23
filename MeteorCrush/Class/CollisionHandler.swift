//
//  CollisionHandler.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//


import SpriteKit

func removeStar(in scene: GameScene, star: inout SKNode) {
    star.removeFromParent()
    let index = scene.stars.firstIndex(where: {$0 === star}) ?? -1
    if(index >= 0){
        scene.stars.remove(at: index)
    }
    let starNewY = scene.size.height * 1 + 100
    // respawn
    ObstacleSpawner.spawnStar(in: scene, atY: starNewY)
}

struct CollisionHandler {
    let scene: GameScene
    let hud: HUD
    static func handle(_ contact: SKPhysicsContact, in scene: GameScene, hud: HUD) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Rocket ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
        case PhysicsCategory.Planet:
            scene.isGameOver = true
            scene.isPaused = true

            NotificationCenter.default.post(
                name: Notification.Name("GameOver"),
                object: hud.score
            )

            let gameOver = SKLabelNode(fontNamed: "AvenirNext-Bold")
            gameOver.text = "Game Over"
            gameOver.fontSize = 48
            gameOver.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
            scene.addChild(gameOver)
        case PhysicsCategory.redStar:
            guard var starNode = other.node, starNode.parent != nil else { return }
            starScoring(scene.rocket.color, .red)
            // other.node?.removeFromParent()
            removeStar(in: scene, star: &starNode)
            hud.starCount = scene.stars.count
        case PhysicsCategory.blueStar:
            guard var starNode = other.node, starNode.parent != nil else { return }
            starScoring(scene.rocket.color, .blue)
            removeStar(in: scene, star: &starNode)
            hud.starCount = scene.stars.count
        case PhysicsCategory.greenStar:
            guard var starNode = other.node, starNode.parent != nil else { return }
            starScoring(scene.rocket.color, .green)
            removeStar(in: scene, star: &starNode)
            hud.starCount = scene.stars.count
        case PhysicsCategory.Fuel:
            guard let starNode = other.node, starNode.parent != nil else { return }
            if let fuelValue = (starNode as? SKSpriteNode)?.userData?["fuelValue"] as? Int {

                hud.fuel = min(hud.fuel + CGFloat(fuelValue), 100)
                print("New fuel level: \(hud.fuel)")
            }
            other.node?.removeFromParent()
            if let index = scene.fuels.firstIndex(where: { $0 === other.node }) {
                scene.fuels.remove(at: index)
            }
            let fuelNewY = scene.size.height * 1 + 200
            ObstacleSpawner.spawnFuel(in: scene, atY: fuelNewY)

        case PhysicsCategory.redGate:
            scene.rocket.texture = SKTexture(imageNamed: "rocketRed")
            scene.rocket.color = .red
            scene.rocket.colorBlendFactor = 0
//            print("lewat pink")        
        case PhysicsCategory.greenGate:
            scene.rocket.texture = SKTexture(imageNamed: "rocketGreen")
            scene.rocket.color = .green
            scene.rocket.colorBlendFactor = 0
//            print("lewat hijau")
        case PhysicsCategory.blueGate:
            scene.rocket.texture = SKTexture(imageNamed: "rocketBlue")
            scene.rocket.color = .blue
            scene.rocket.colorBlendFactor = 0
//            print("lewat biru")
        default: break
        }
        
        func starScoring(_ rocketColor: UIColor, _ starColor: UIColor){
//            print(rocketColor, starColor)
            if (rocketColor == .red && starColor == .red) || (rocketColor == .green && starColor == .green) || (rocketColor == .blue && starColor == .blue)
            {
                hud.score += 5
            } else
            {
                if hud.score > 0{
                    hud.score -= 1
                }
            }
        }
    }
}
