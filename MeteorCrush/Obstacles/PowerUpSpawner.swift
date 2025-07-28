//
//  PowerUpSpawner.swift
//  MeteorCrush
//
//  Created by Ammar Alifian Fahdan on 21/07/25.
//

import Foundation
import SpriteKit

enum PowerupType: String {
    case doubleScore
    case shield
}

struct PowerUpSpawner {
    var lastSpawnTime: Int = 0
    
    static func spawnPowerup(in scene: GameScene, y: CGFloat) {
        let powerUpType: PowerupType = Bool.random() ? .doubleScore : .shield

        let powerup = SKSpriteNode(imageNamed: powerUpType == .doubleScore ? "powerUp2x" : "powerUpShield")
        let diameter = 200.0
        powerup.size = CGSize(width: diameter, height: diameter)
        powerup.position = CGPoint(x: CGFloat.random(in: 0...(scene.size.width)), y: y)
        powerup.zPosition = 5
        powerup.userData = ["type": powerUpType.rawValue]
        
        let body = SKPhysicsBody(circleOfRadius: diameter / 6)
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.powerUp
        body.contactTestBitMask = PhysicsCategory.Rocket
        body.collisionBitMask = PhysicsCategory.None
        powerup.physicsBody = body
    
        scene.powerups.append(powerup)
        scene.addChild(powerup)

//        print("Powerup spawned. Type: \(powerUpType.rawValue)")
    }

    
    static func recyclePowerup(in scene: GameScene, speed: CGFloat) {
        let offscreenY: CGFloat = -100
        let second = Int(floor(CGFloat(scene.distance / 5)))
        let startingSecond = 1
        let interval = 3
        if(second >= startingSecond && (second - startingSecond) % interval == 0 && scene.powerups.count == 0){
            spawnPowerup(in: scene, y: scene.size.height)
        }
        
        scene.powerups.forEach { powerup in
            if powerup.position.y < offscreenY {
                scene.powerups.removeAll { $0 === powerup }
            }
        }
    }
}
