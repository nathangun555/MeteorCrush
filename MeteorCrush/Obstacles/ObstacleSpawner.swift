//
//  ObstacleSpawner.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

struct ObstacleSpawner {
    static func spawnPlanet(in scene: SKScene, atY y: CGFloat) -> SKSpriteNode {
            let planet = SKSpriteNode(imageNamed: "planet")
            planet.size = CGSize(width: 200, height: 100)
            let halfW = planet.size.width / 2
            planet.position = CGPoint(
                x: CGFloat.random(in: halfW...(scene.size.width - halfW)),
                y: y
            )
            planet.zPosition = 5
            planet.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
            planet.physicsBody?.categoryBitMask = PhysicsCategory.Planet
            planet.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
            planet.physicsBody?.collisionBitMask = PhysicsCategory.None
            planet.physicsBody?.affectedByGravity = false
            return planet
        }
    static func spawnStar(in scene: SKScene, atY y: CGFloat) {
        let star = SKSpriteNode(imageNamed: "star")
        star.size = CGSize(width: 50, height: 50)
        let halfW = star.size.width/2
        star.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        star.zPosition = 5
        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        star.physicsBody?.categoryBitMask = PhysicsCategory.Star
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false
        scene.addChild(star)
    }
    static func spawnFuel(in scene: SKScene, atY y: CGFloat) {
        let pickup = SKSpriteNode(imageNamed: "fuel")
        pickup.size = CGSize(width: 50, height: 50)
        let halfW = pickup.size.width/2
        pickup.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        pickup.zPosition = 5
        pickup.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        pickup.physicsBody?.categoryBitMask = PhysicsCategory.Fuel
        pickup.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        pickup.physicsBody?.collisionBitMask = PhysicsCategory.None
        pickup.physicsBody?.affectedByGravity = false
        scene.addChild(pickup)
    }
    static func recycleOffscreen(in scene: GameScene, speed: CGFloat) {
        let offscreenY: CGFloat = -100, topY: CGFloat = scene.size.height + 100
        scene.planets.forEach { p in
            if p.position.y < offscreenY {
                p.position.y = topY + CGFloat.random(in: 0...200)
                p.position.x = CGFloat.random(in: p.size.width/2...(scene.size.width-p.size.width/2))
            }
        }
        scene.stars.forEach { s in
            if s.position.y < offscreenY {
                s.position.y = topY + CGFloat.random(in: 0...200)
                s.position.x = CGFloat.random(in: s.size.width/2...(scene.size.width-s.size.width/2))
            }
        }
        scene.fuels.forEach { f in
            if f.position.y < offscreenY {
                f.position.y = topY + CGFloat.random(in: 0...200)
                f.position.x = CGFloat.random(in: f.size.width/2...(scene.size.width-f.size.width/2))
            }
        }
    }
}
