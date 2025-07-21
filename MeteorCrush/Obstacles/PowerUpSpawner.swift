//
//  PowerUpSpawner.swift
//  MeteorCrush
//
//  Created by Ammar Alifian Fahdan on 21/07/25.
//

import Foundation
import SpriteKit

enum PowerupType {
    case doubleScore
    case shield
}

struct PowerUpSpawner {
    static func spawnPowerup(in scene: SKScene, y: CGFloat) {
        let powerUpType: PowerupType
        
        if(Int.random(in: 0...1) == 0){
            powerUpType = .doubleScore
        }else{
            powerUpType = .shield
        }
        
        
        let powerup = SKSpriteNode(imageNamed: powerUpType == .doubleScore ? "powerUp2x" : "powerUpShield")
        powerup.size = CGSize(width: 50, height: 50)
        powerup.position = CGPoint(x: CGFloat.random(in: (500.0 / 2)...(scene.size.width - 500.0 / 2)), y: y)
        powerup.zPosition = 10
        scene.addChild(powerup)
    }
}
