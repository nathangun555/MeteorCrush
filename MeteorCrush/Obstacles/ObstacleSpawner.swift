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
        scene.addChild(planet) // ✅ Perbaikan di sini
    }
    static func spawnStar(in scene: SKScene, atY y: CGFloat) {
        let starColors = ["redStar", "greenStar", "blueStar"]
        var starPicker = starColors.randomElement()!
        let star = SKSpriteNode(imageNamed: starPicker)
        star.size = CGSize(width: 50, height: 50)
        let halfW = star.size.width/2
        star.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        star.zPosition = 5
        star.blendMode = .alpha
        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        if starPicker == "redStar"
        {
            star.physicsBody?.categoryBitMask = PhysicsCategory.redStar
        } else if starPicker == "greenStar"
        {
            star.physicsBody?.categoryBitMask = PhysicsCategory.greenStar
        } else
        {
            star.physicsBody?.categoryBitMask = PhysicsCategory.blueStar
        }
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false
        if let gs = scene as? GameScene {
            gs.stars.append(star)
        }
        scene.addChild(star)
        print("Star spawned")
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
            gs.fuels.append(pickup)
        }
        scene.addChild(pickup)
    }
    static func spawnGate(in scene: SKScene, atY y: CGFloat) {
        let gate = SKSpriteNode(imageNamed: "whiteGate")
        let colors: [SKColor] = [.red, .green, .blue]
            if let randomColor = colors.randomElement() {
                gate.color = randomColor
                gate.colorBlendFactor = 1  // 1.0 = full tint
                print("gate color is \(randomColor)")
            }
        gate.size = CGSize(width: 400, height: 100)
        let halfW = gate.size.width/2
        gate.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        gate.zPosition = 5
        gate.blendMode = .alpha
        gate.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        if gate.color == .red
        {
            gate.physicsBody?.categoryBitMask = PhysicsCategory.redGate
        } else if gate.color == .green
        {
            gate.physicsBody?.categoryBitMask = PhysicsCategory.greenGate
        } else
        {
            gate.physicsBody?.categoryBitMask = PhysicsCategory.blueGate
        }
        gate.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        gate.physicsBody?.collisionBitMask = PhysicsCategory.None
        gate.physicsBody?.affectedByGravity = false
        if let gs = scene as? GameScene {
            gs.fuels.append(gate)
        }
        scene.addChild(gate)
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
        scene.gate.forEach { g in
            if g.position.y < offscreenY {
                g.position.y = topY + CGFloat.random(in: 0...200)
                g.position.x = CGFloat.random(in: g.size.width/2...(scene.size.width-g.size.width/2))
            }
        }
    }
}
