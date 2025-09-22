//
//  FuelSpawner.swift
//  MeteorCrush
//
//  Created by Ammar Alifian Fahdan on 07/08/25.
//

import Foundation
import SpriteKit

struct FuelSpawner {
    
    // Helper function to check if a new fuel collides with existing collectibles
    static func checkCollisionWithCollectibles(in scene: GameScene, position: CGPoint, radius: CGFloat) -> Bool {
        // Check collision with red stars
        for star in scene.redStar {
            let starRadius = star.size.width / 3.5
            if ObstacleSpawner.circlesCollide(center1: position, radius1: radius, 
                            center2: star.position, radius2: starRadius) {
                return true
            }
        }
        
        // Check collision with green stars
        for star in scene.greenStar {
            let starRadius = star.size.width / 3.5
            if ObstacleSpawner.circlesCollide(center1: position, radius1: radius, 
                            center2: star.position, radius2: starRadius) {
                return true
            }
        }
        
        // Check collision with blue stars
        for star in scene.blueStar {
            let starRadius = star.size.width / 3.5
            if ObstacleSpawner.circlesCollide(center1: position, radius1: radius, 
                            center2: star.position, radius2: starRadius) {
                return true
            }
        }
        
        // Check collision with other fuels
        for fuel in scene.fuels {
            let fuelRadius = fuel.size.width / 3.5
            if ObstacleSpawner.circlesCollide(center1: position, radius1: radius, 
                            center2: fuel.position, radius2: fuelRadius) {
                return true
            }
        }
        
        // Check collision with powerups
        for powerup in scene.powerups {
            let powerupRadius = powerup.size.width / 6
            if ObstacleSpawner.circlesCollide(center1: position, radius1: radius, 
                            center2: powerup.position, radius2: powerupRadius) {
                return true
            }
        }
        
        // Check collision with planets
        for planet in scene.planets {
            let planetRadius = planet.size.width / 3 // Using collision radius from planet spawn
            if ObstacleSpawner.circlesCollide(center1: position, radius1: radius, 
                            center2: planet.position, radius2: planetRadius) {
                return true
            }
        }
        
        // Check collision with gates
        for gate in scene.gate {
            let gateWidth = gate.size.width
            let gateHeight = gate.size.height
            let gateX = gate.position.x
            let gateY = gate.position.y
            
            // Check if fuel position is within gate bounds
            let gateLeft = gateX - gateWidth / 2
            let gateRight = gateX + gateWidth / 2
            let gateTop = gateY + gateHeight / 2
            let gateBottom = gateY - gateHeight / 2
            
            // Check if the fuel circle intersects with the gate rectangle
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
    
    // Helper function to find a valid position for fuel
    static func findValidPosition(in scene: GameScene, y: CGFloat, radius: CGFloat, maxAttempts: Int = 100) -> CGPoint? {
        let halfW = radius
        let minX = halfW
        let maxX = scene.size.width - halfW
        
        for _ in 0..<maxAttempts {
            let randomX = CGFloat.random(in: minX...maxX)
            let position = CGPoint(x: randomX, y: y)
            
            if !checkCollisionWithCollectibles(in: scene, position: position, radius: radius) {
                return position
            }
        }
        
        return nil
    }
    
    static func spawnFuel(in scene: GameScene, atY y: CGFloat) {
        let fuelColors = ["fuel10", "fuel20", "fuel30", "fuel40", "fuel20", "fuel30", "fuel40", "fuel30", "fuel30", "fuel40"]
        let fuelPicker = fuelColors.randomElement()!
        let pickup = SKSpriteNode(imageNamed: fuelPicker)
        pickup.size = CGSize(width: 200, height: 200)

        // Assign the fuel value based on the name of the image
        let fuelValue: Int
        switch fuelPicker {
        case "fuel10":
            fuelValue = 10
        case "fuel20":
            fuelValue = 20
        case "fuel30":
            fuelValue = 30
        case "fuel40":
            fuelValue = 40
        default:
            fuelValue = 0
        }

        // Store the fuel value in the user data
        pickup.userData = ["fuelValue": fuelValue]

        let halfW = pickup.size.width / 2
        let collisionRadius = halfW / 3.5
        
        // Use random X position within screen bounds
        let randomX = CGFloat.random(in: halfW...(scene.size.width - halfW))
        pickup.position = CGPoint(x: randomX, y: y)
        pickup.zPosition = 5
        pickup.blendMode = .alpha

        // Setup physics body
        pickup.physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius)
        pickup.physicsBody?.categoryBitMask = PhysicsCategory.Fuel
        pickup.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        pickup.physicsBody?.collisionBitMask = PhysicsCategory.None
        pickup.physicsBody?.affectedByGravity = false

        // Collision circle (for debugging or visual purposes)
        let collisionCircle = SKShapeNode(circleOfRadius: collisionRadius)
        collisionCircle.position = .zero
        collisionCircle.strokeColor = .clear
        collisionCircle.lineWidth = 2
        collisionCircle.fillColor = .clear
        collisionCircle.zPosition = -100
        pickup.addChild(collisionCircle)

        // Check for collisions with planets
        if let gs = scene as? GameScene {
            let planetPadding: CGFloat = 30
            for planet in gs.planets {
                let lowBoundX = planet.position.x - planet.size.width / 2 - planetPadding
                let highBoundX = planet.position.x + planet.size.width / 2 + planetPadding
                let lowBoundY = planet.position.y - planet.size.height / 2 - planetPadding
                let highBoundY = planet.position.y + planet.size.height / 2 + planetPadding

                if pickup.position.x > lowBoundX && pickup.position.x < highBoundX {
                    pickup.position.x = Int.random(in: 0...1) == 0 ? lowBoundX : highBoundX
                }

                if pickup.position.y > lowBoundY && pickup.position.y < highBoundY {
                    pickup.position.y = Int.random(in: 0...1) == 0 ? lowBoundY : highBoundY
                }
            }
            gs.fuels.append(pickup)
        }

        scene.addChild(pickup)
    }
    
    static func recycleFuel(in scene: GameScene, speed: CGFloat) {
        let topY: CGFloat = scene.size.height + 10
        
        scene.fuels.forEach { f in
            if 25 >= (scene.size.width-25) {
                print("Issue in fuel! \(25) < \(scene.size.width-25)")
            }
            if f.position.y < 0 {
                let fuelRadius = f.size.width / 3.5
                let newY = topY + CGFloat.random(in: 0...200)
                
                // Find a valid position that doesn't collide with other collectibles
                if let validPosition = findValidPosition(in: scene, y: newY, radius: fuelRadius) {
                    f.position = validPosition
                } else {
                    // If no valid position found, use a random position but mark for removal
                    f.position.x = CGFloat.random(in: 25...(scene.size.width-25))
                    f.position.y = newY
                }
            }
        }
    }
}


