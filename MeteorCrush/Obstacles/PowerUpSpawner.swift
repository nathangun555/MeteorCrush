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
    
    // Helper function to check if a position collides with gates
    static func checkCollisionWithGates(in scene: GameScene, position: CGPoint, radius: CGFloat) -> Bool {
        for gate in scene.gate {
            let gateWidth = gate.size.width
            let gateHeight = gate.size.height
            let gateX = gate.position.x
            let gateY = gate.position.y
            
            // Check if position is within gate bounds
            let gateLeft = gateX - gateWidth / 2
            let gateRight = gateX + gateWidth / 2
            let gateTop = gateY + gateHeight / 2
            let gateBottom = gateY - gateHeight / 2
            
            // Check if the circle intersects with the gate rectangle
            let closestX = max(gateLeft, min(position.x, gateRight))
            let closestY = max(gateBottom, min(position.y, gateTop))
            
            let distanceX = position.x - closestX
            let distanceY = position.y - closestY
            let distanceSquared = distanceX * distanceX + distanceY * distanceY
            
            if distanceSquared <= radius * radius {
                return true
            }
        }
        return false
    }
    
    static func spawnPowerup(in scene: GameScene, y: CGFloat) {
        let powerUpType: PowerupType = Bool.random() ? .doubleScore : .shield

        let powerup = SKSpriteNode(imageNamed: powerUpType == .doubleScore ? "powerUp2x" : "powerUpShield")
        let diameter = 300.0
        powerup.size = CGSize(width: diameter, height: diameter)
        
        let collisionRadius = diameter / 6
        
        // Find a valid position that doesn't collide with other collectibles
        guard let validPosition = ObstacleSpawner.findValidPosition(in: scene, y: y, radius: collisionRadius) else {
            return // Skip spawning if no valid position found
        }
        
        // Additional check for gate collision
        if checkCollisionWithGates(in: scene, position: validPosition, radius: collisionRadius) {
            return // Skip spawning if collides with gates
        }
        
        powerup.position = validPosition
        powerup.zPosition = 5
        powerup.userData = ["type": powerUpType.rawValue]
        
        let body = SKPhysicsBody(circleOfRadius: collisionRadius)
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
        let startingSecond = 5
        let interval = 20
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
