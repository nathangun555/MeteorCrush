//
//  CollisionHandler.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//


import SpriteKit

func removeStar(in scene: GameScene, star: inout SKNode, starColor: String) {
    star.removeFromParent()
    if starColor == "redStar"{
        let index = scene.redStar.firstIndex(where: {$0 === star}) ?? -1
        if(index >= 0){
            scene.redStar.remove(at: index)
        }
        let starNewY = scene.size.height * 1 + 100
        // respawn
        ObstacleSpawner.spawnStar(in: scene, atY: starNewY)
    } else if starColor == "greenStar"
    {
        let index = scene.greenStar.firstIndex(where: {$0 === star}) ?? -1
        if(index >= 0){
            scene.greenStar.remove(at: index)
        }
        let starNewY = scene.size.height * 1 + 100
        // respawn
        ObstacleSpawner.spawnGreenStar(in: scene, atY: starNewY)
    } else
    {
        let index = scene.blueStar.firstIndex(where: {$0 === star}) ?? -1
        if(index >= 0){
            scene.blueStar.remove(at: index)
        }
        let starNewY = scene.size.height * 1 + 100
        // respawn
        ObstacleSpawner.spawnBlueStar(in: scene, atY: starNewY)
    }
   
}

struct CollisionHandler {
    let scene: GameScene
    let hud: HUD
    static func handle(_ contact: SKPhysicsContact, in scene: GameScene, hud: HUD) {
        let first = contact.bodyA
        let second = contact.bodyB
        
        // Cek jika salah satu adalah Rocket dan satu lagi Meteor
        if (first.categoryBitMask == PhysicsCategory.Rocket && second.categoryBitMask == PhysicsCategory.Meteor) ||
            (first.categoryBitMask == PhysicsCategory.Meteor && second.categoryBitMask == PhysicsCategory.Rocket) {
            
            print("[Collision] 🚨 Rocket hit meteor!")
            vibrateWithDelay(.heavy, count: 3, delayInterval: 0.1)
            ExplosionEffects.playExplosion(at: scene.rocket.position, in: scene) {
                NotificationCenter.default.post(
                    name: Notification.Name("GameOver"),
                    object: hud.score
                )
                scene.isGameOver = true
                scene.isPaused = true
                scene.meteorSpawner.stopSpawning()
                print("tabrak meteor")
                
            }
            return
        }
        
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Rocket ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
            
        case PhysicsCategory.Planet:
            
            NotificationCenter.default.post(
                name: Notification.Name("GameOver"),
                object: hud.score
            )
            
            vibrateWithDelay(.heavy, count: 3, delayInterval: 0.1)
            ExplosionEffects.playExplosion(at: scene.rocket.position, in: scene) {
                
                scene.isGameOver = true
                scene.isPaused = true
               scene.meteorSpawner.stopSpawning()

            }
            return
            
        case PhysicsCategory.gateEdge:
            
            NotificationCenter.default.post(
                name: Notification.Name("GameOver"),
                object: hud.score
            )
           // SoundManager.shared.playSFX(named: "gameOver", withExtension: "wav")
            vibrateWithDelay(.heavy, count: 3, delayInterval: 0.1)
            ExplosionEffects.playExplosion(at: scene.rocket.position, in: scene) {
                
                scene.isGameOver = true
                scene.isPaused = true
                scene.meteorSpawner.stopSpawning()
            
            }
            return
            
        case PhysicsCategory.redStar:
            guard var starNode = other.node, starNode.parent != nil else { return }
            starScoring(scene.rocket.color, .red)
            // other.node?.removeFromParent()
            removeStar(in: scene, star: &starNode, starColor: "redStar")
        case PhysicsCategory.blueStar:
            guard var starNode = other.node, starNode.parent != nil else { return }
            starScoring(scene.rocket.color, .blue)
            removeStar(in: scene, star: &starNode, starColor: "blueStar")
        case PhysicsCategory.greenStar:
            guard var starNode = other.node, starNode.parent != nil else { return }
            starScoring(scene.rocket.color, .green)
            removeStar(in: scene, star: &starNode, starColor: "greenStar")
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
                SoundManager.shared.playSFX(named: "collectStar", withExtension: "wav")
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
