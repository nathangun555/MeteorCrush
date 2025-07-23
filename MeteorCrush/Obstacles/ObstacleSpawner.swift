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
            let randomSize = CGFloat.random(in: 150...300)
            planet.size = CGSize(width: randomSize, height: randomSize)
            let halfW = planet.size.width / 2
            let maxOutsideFraction: CGFloat = 0.3
            let offset = planet.size.width * maxOutsideFraction

            let newX = CGFloat.random(in: -offset...(scene.size.width + offset))
            let newY = y

        if let gs = scene as? GameScene {
            let minHorizontalGap: CGFloat = 2
            let minVerticalGap: CGFloat = 5

                for existing in gs.planets {
                    let dx = abs(existing.position.x - newX)
                    let dy = abs(existing.position.y - newY)
                    if dx < minHorizontalGap && dy < minVerticalGap {
                        // terlalu dekat, batal spawn
                        return
                    }
                }
            }

            planet.position = CGPoint(x: newX, y: newY)
            planet.zPosition = 5

            let collisionRadius = halfW / 1.5
            let collisionCircle = SKShapeNode(circleOfRadius: collisionRadius)
            collisionCircle.position    = .zero
            collisionCircle.strokeColor = .yellow
            collisionCircle.lineWidth   = 2
            collisionCircle.fillColor   = .clear
            collisionCircle.zPosition   = -1

            let body = SKPhysicsBody(circleOfRadius: collisionRadius)
            body.isDynamic = false
            body.categoryBitMask = PhysicsCategory.Planet
            body.contactTestBitMask = PhysicsCategory.Rocket
            body.collisionBitMask = PhysicsCategory.None
            collisionCircle.physicsBody = body

            planet.addChild(collisionCircle)

            if let gs = scene as? GameScene {
                gs.planets.append(planet)
            }

            scene.addChild(planet)
        }
    
    static func spawnStar(in scene: SKScene, atY y: CGFloat) {
        let starColors = ["starRed", "starBlue", "starGreen"]
        let starPicker = starColors.randomElement()!
        let star = SKSpriteNode(imageNamed: starPicker)
        star.size = CGSize(width: 50, height: 50)
        let halfW = star.size.width/2
        star.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        star.zPosition = 5
        star.blendMode = .alpha
        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        if starPicker == "starRed"
        {
            star.physicsBody?.categoryBitMask = PhysicsCategory.redStar
        } else if starPicker == "starBlue"
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
        let fuelColors = ["fuel10", "fuel20", "fuel30", "fuel40"]
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
        pickup.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width - halfW)), y: y)
        pickup.zPosition = 5
        pickup.blendMode = .alpha

        // Setup physics body
        pickup.physicsBody = SKPhysicsBody(circleOfRadius: halfW/3.5)
        pickup.physicsBody?.categoryBitMask = PhysicsCategory.Fuel
        pickup.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        pickup.physicsBody?.collisionBitMask = PhysicsCategory.None
        pickup.physicsBody?.affectedByGravity = false

        // Collision circle (for debugging or visual purposes)
        let collisionCircle = SKShapeNode(circleOfRadius: halfW/3.5 )
        collisionCircle.position = .zero
        collisionCircle.strokeColor = .yellow
        collisionCircle.lineWidth = 2
        collisionCircle.fillColor = .clear
        collisionCircle.zPosition = -1
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


    static func spawnGate(in scene: SKScene, atY y: CGFloat) {
        let gate = SKSpriteNode(imageNamed: "whiteGate")
        let colors: [SKColor] = [.red, .green, .blue]
        let randomIndex = Int.random(in: 0...2)
        gate.color = colors[randomIndex]
        gate.colorBlendFactor = 1.0
        
        print("Spawn a new gate")
        print(gate.color)
        gate.size = CGSize(width: scene.size.width * 0.4, height: scene.size.height * 0.3)
        let halfW = gate.size.width / 2
        gate.position = CGPoint(
            x: halfW,
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
            gs.gate.append(gate)
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
            if s.size.width/2 >= (scene.size.width-s.size.width/2) {
                print("Issue in star! \(50 / 2) < \(scene.size.width-50/2)")
            }
            if s.position.y < offscreenY {
                s.position.x = CGFloat.random(in: s.size.width/2...(scene.size.width-s.size.width/2))
                s.position.y = topY + CGFloat.random(in: 0...200)
            }
        }
        scene.fuels.forEach { f in
            if 25 >= (scene.size.width-25) {
                print("Issue in fuel! \(25) < \(scene.size.width-25)")
            }
//            print(f.size.width / 2, scene.size.width - f.size.width / 2)
            if f.position.y < offscreenY {
                f.position.x = CGFloat.random(in: 25...(scene.size.width-25))
                f.position.y = topY + CGFloat.random(in: 0...200)
            }
        }
        scene.gate.forEach { g in
            if g.position.y < offscreenY {
                scene.gate.removeAll()
                spawnGate(in: scene, atY: topY + CGFloat.random(in: 0...200))
            }
        }
    }
}
