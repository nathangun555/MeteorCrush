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
        let randomSize = CGFloat.random(in: 70...150)
        planet.size = CGSize(width: randomSize, height: randomSize)
        let halfW = planet.size.width / 2
        planet.position = CGPoint(
            x: CGFloat.random(in: halfW...(scene.size.width - halfW)),
            y: y
        )
        planet.zPosition = 5
        
        let collisionRadius = halfW / 1.5
        let collisionCircle = SKShapeNode(circleOfRadius: collisionRadius)
        collisionCircle.position    = .zero
        collisionCircle.strokeColor = .yellow
        collisionCircle.lineWidth   = 2
        collisionCircle.fillColor   = .clear
        collisionCircle.zPosition   = -1   // agar di belakang planet
        
        let body = SKPhysicsBody(circleOfRadius: collisionRadius)
        body.isDynamic            = false  // statis, ikut planet
        body.categoryBitMask      = PhysicsCategory.Planet
        body.contactTestBitMask   = PhysicsCategory.Rocket
        body.collisionBitMask     = PhysicsCategory.None
        collisionCircle.physicsBody = body
        
        planet.addChild(collisionCircle)
        
        if let gs = scene as? GameScene {
            gs.planets.append(planet)
        }
        scene.addChild(planet)
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
    static func spawnGate(in scene: SKScene, atY y: CGFloat) {
        let gate = SKSpriteNode(imageNamed: "whiteGate")
        let colors: [SKColor] = [.red, .green, .blue]
        if let randomColor = colors.randomElement() {
            gate.color = randomColor
            gate.colorBlendFactor = 1.0
        }
        gate.size = CGSize(width: scene.size.width * 0.4, height: scene.size.height * 0.3)
        let halfW = gate.size.width / 2
        gate.position = CGPoint(
            x: CGFloat.random(in: halfW...(scene.size.width - halfW)),
            y: y
        )
        gate.zPosition = 5
        let rectSize = CGSize(width: gate.size.width, height: gate.size.height * 0.001)
        let collisionRect = SKShapeNode(rectOf: rectSize, cornerRadius: 0)
        collisionRect.position    = .zero
        collisionRect.strokeColor = .yellow    // untuk debug, tandanya
        collisionRect.lineWidth   = 2
        collisionRect.fillColor   = .clear
        collisionRect.zPosition   = -1         // di belakang gate
        
        let body = SKPhysicsBody(rectangleOf: rectSize)
        body.isDynamic            = false
        
        switch gate.color {
        case .red:
            body.categoryBitMask = PhysicsCategory.redGate
        case .green:
            body.categoryBitMask = PhysicsCategory.greenGate
        default:
            body.categoryBitMask = PhysicsCategory.blueGate
        }
        
        body.contactTestBitMask   = PhysicsCategory.Rocket
        body.collisionBitMask     = PhysicsCategory.None
        collisionRect.physicsBody = body
        
        gate.addChild(collisionRect)
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
