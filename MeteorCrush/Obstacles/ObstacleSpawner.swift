//
//  ObstacleSpawner.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

struct ObstacleSpawner {
    static func spawnPlanet(in scene: SKScene, atY y: CGFloat) {
        let planet = SKSpriteNode(imageNamed: "planet")
        let randomSize = CGFloat.random(in: 50...100)
        planet.size = CGSize(width: randomSize, height: randomSize)
        let halfW = planet.size.width / 2
        planet.position = CGPoint(
            x: CGFloat.random(in: halfW...(scene.size.width - halfW)),
            y: y
        )
        planet.zPosition = 5
        planet.blendMode = .alpha
        planet.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        planet.physicsBody?.categoryBitMask = PhysicsCategory.Planet
        planet.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        planet.physicsBody?.collisionBitMask = PhysicsCategory.None
        planet.physicsBody?.affectedByGravity = false
        if let gs = scene as? GameScene {
            gs.planets.append(planet)
        }
        scene.addChild(planet)
    }
    static func spawnStar(in scene: SKScene, atY y: CGFloat) {
        let star = SKSpriteNode(imageNamed: "star")
        print("Star spawned!")
        star.size = CGSize(width: 50, height: 50)
        let halfW = star.size.width/2
        star.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        star.zPosition = 5
        star.blendMode = .alpha
        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        star.physicsBody?.categoryBitMask = PhysicsCategory.Star
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false
        if let gs = scene as? GameScene {
            let planetPadding: CGFloat = 30
            for planet in gs.planets {
                let lowBoundX = planet.position.x - planet.size.width/2 - planetPadding
                let highBoundX = planet.position.x + planet.size.width/2 + planetPadding
                let lowBoundY = planet.position.y - planet.size.height/2 - planetPadding
                let highBoundY = planet.position.y + planet.size.height/2 + planetPadding
                
                if(star.position.x > lowBoundX && star.position.x < highBoundX){
                    star.position.x = Int.random(in: 0...1) == 0 ? lowBoundX : highBoundX
                }
                
                if(star.position.y > lowBoundY && star.position.y < highBoundY){
                    star.position.y = Int.random(in: 0...1) == 0 ? lowBoundY : highBoundY
                }
            }
            gs.stars.append(star)
        }
        scene.addChild(star)
    }
    static func spawnFuel(in scene: SKScene, atY y: CGFloat) {
        let pickup = SKSpriteNode(imageNamed: "fuel")
        pickup.size = CGSize(width: 50, height: 50)
        let halfW = pickup.size.width/2
        pickup.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        pickup.zPosition = 5
        pickup.blendMode = .alpha
        pickup.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        pickup.physicsBody?.categoryBitMask = PhysicsCategory.Fuel
        pickup.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        pickup.physicsBody?.collisionBitMask = PhysicsCategory.None
        pickup.physicsBody?.affectedByGravity = false
        if let gs = scene as? GameScene {
            let planetPadding: CGFloat = 30
            for planet in gs.planets {
                let lowBoundX = planet.position.x - planet.size.width/2 - planetPadding
                let highBoundX = planet.position.x + planet.size.width/2 + planetPadding
                let lowBoundY = planet.position.y - planet.size.height/2 - planetPadding
                let highBoundY = planet.position.y + planet.size.height/2 + planetPadding
                
                if(pickup.position.x > lowBoundX && pickup.position.x < highBoundX){
                    pickup.position.x = Int.random(in: 0...1) == 0 ? lowBoundX : highBoundX
                }
                
                if(pickup.position.y > lowBoundY && pickup.position.y < highBoundY){
                    pickup.position.y = Int.random(in: 0...1) == 0 ? lowBoundY : highBoundY
                }
            }
            gs.fuels.append(pickup)
        }
        scene.addChild(pickup)
    }
    static func recycleOffscreen(in scene: GameScene, speed: CGFloat) {
        let offscreenY: CGFloat = -100, topY: CGFloat = scene.size.height + 10
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
