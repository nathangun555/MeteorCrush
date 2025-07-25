//
//  ObstacleSpawner.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

struct ObstacleSpawner {
//    static func spawnPlanet(in scene: SKScene, atY y: CGFloat) {
//        let planet = SKSpriteNode(imageNamed: "planet")
//        let randomSize = CGFloat.random(in: 150...300)
//        planet.size = CGSize(width: randomSize, height: randomSize)
//        let halfW = planet.size.width / 2
//        planet.position = CGPoint(
//            x: CGFloat.random(in: halfW...(scene.size.width - halfW)),
//            y: y
//        )
//        planet.zPosition = 5
//        
//        let collisionRadius = halfW / 1.5
//        let collisionCircle = SKShapeNode(circleOfRadius: collisionRadius)
//        collisionCircle.position    = .zero
//        collisionCircle.strokeColor = .yellow
//        collisionCircle.lineWidth   = 2
//        collisionCircle.fillColor   = .clear
//        collisionCircle.zPosition   = -1   // agar di belakang planet
//        
//        let body = SKPhysicsBody(circleOfRadius: collisionRadius)
//        body.isDynamic            = false  // statis, ikut planet
//        body.categoryBitMask      = PhysicsCategory.Planet
//        body.contactTestBitMask   = PhysicsCategory.Rocket
//        body.collisionBitMask     = PhysicsCategory.None
//        collisionCircle.physicsBody = body
//        
//        planet.addChild(collisionCircle)
//        
//        if let gs = scene as? GameScene {
//            gs.planets.append(planet)
//        }
//        scene.addChild(planet)
//    }
    var lastPlanetPos = 0
    
    static func getPlanetXPos(scene: GameScene, planet: SKSpriteNode, index: Int) -> CGFloat {
        print("Calling getPlanetXPos(index: \(index))")
        var upperBoundX: CGFloat = 0.0, lowerBoundX: CGFloat = 0.0
        let planetPosType = index % 2
        if planetPosType == 0 {
            // 0 = kanan
            upperBoundX = scene.size.width + planet.size.width / 2 - 100
            lowerBoundX = scene.size.width
            print("Kanan")
        }else if(planetPosType == 1){
            // 1 = kiri
            lowerBoundX = -planet.size.width / 2 + 100
            upperBoundX = 0.0
            print("Kiri")
        }
        
        return CGFloat.random(in: lowerBoundX...upperBoundX)
    }
    
    static func spawnPlanet(in scene: GameScene, atY y: CGFloat, index: Int) {
        let planets = [SKSpriteNode(imageNamed: "planet1"), SKSpriteNode(imageNamed: "planet2"), SKSpriteNode(imageNamed: "planet3"), SKSpriteNode(imageNamed: "planet4"), SKSpriteNode(imageNamed: "planet5")]
        let planetPicker = planets.randomElement()!

        let planet = planetPicker
        let randomSize = 500.0
        planet.size = CGSize(width: randomSize, height: randomSize)
        let halfW = planet.size.width / 2
        
        let newX = getPlanetXPos(scene: scene, planet: planet, index: index)
        let newY = y

            // ➤ Cek jarak dengan planet yang sudah ada
//            if let gs = scene as? GameScene {
//                let minHorizontalGap: CGFloat = 2
//                let minVerticalGap: CGFloat = 5
//
//                for existing in gs.planets {
//                    let dx = abs(existing.position.x - newX)
//                    let dy = abs(existing.position.y - newY)
//                    if dx < minHorizontalGap && dy < minVerticalGap {
//                        // terlalu dekat, batal spawn
//                        return
//                    }
//                }
//            }

            planet.position = CGPoint(x: newX, y: newY)
            planet.zPosition = 5
            print(newX, newY)

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

    static func spawnStar(in scene: GameScene, atY y: CGFloat) {
        guard let gs = scene as? GameScene else { return }

        let star = SKSpriteNode(imageNamed: "redStar")
        star.size = CGSize(width: 50, height: 50)
        let halfW = star.size.width/2
        star.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        star.zPosition = 5
        star.blendMode = .alpha
        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        star.physicsBody?.categoryBitMask = PhysicsCategory.redStar
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false

        let planetPadding: CGFloat = 30
            for planet in gs.planets {
//                let lowBoundX = planet.position.x - planet.size.width/2 - planetPadding
//                let highBoundX = planet.position.x + planet.size.width/2 + planetPadding
//                let lowBoundY = planet.position.y - planet.size.height/2 - planetPadding
//                let highBoundY = planet.position.y + planet.size.height/2 + planetPadding
                
//                if(star.position.x > lowBoundX && star.position.x < highBoundX){
//                    star.position.x = Int.random(in: 0...1) == 0 ? lowBoundX : highBoundX
//                }
//                
//                if(star.position.y > lowBoundY && star.position.y < highBoundY){
//                    star.position.y = Int.random(in: 0...1) == 0 ? lowBoundY : highBoundY
//                }
            }
        gs.redStar.append(star)
        
        scene.addChild(star)
    }
    static func spawnGreenStar(in scene: GameScene, atY y: CGFloat) {
        guard let gs = scene as? GameScene else { return }

        let star = SKSpriteNode(imageNamed: "greenStar")
        star.size = CGSize(width: 50, height: 50)
        let halfW = star.size.width/2
        star.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        star.zPosition = 5
        star.blendMode = .alpha
        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        star.physicsBody?.categoryBitMask = PhysicsCategory.greenStar
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false

        let planetPadding: CGFloat = 30
            for planet in gs.planets {
//                let lowBoundX = planet.position.x - planet.size.width/2 - planetPadding
//                let highBoundX = planet.position.x + planet.size.width/2 + planetPadding
//                let lowBoundY = planet.position.y - planet.size.height/2 - planetPadding
//                let highBoundY = planet.position.y + planet.size.height/2 + planetPadding
//                
//                if(star.position.x > lowBoundX && star.position.x < highBoundX){
//                    star.position.x = Int.random(in: 0...1) == 0 ? lowBoundX : highBoundX
//                }
//                
//                if(star.position.y > lowBoundY && star.position.y < highBoundY){
//                    star.position.y = Int.random(in: 0...1) == 0 ? lowBoundY : highBoundY
//                }
            }
        gs.greenStar.append(star)
        
        scene.addChild(star)
    }
    static func spawnBlueStar(in scene: GameScene, atY y: CGFloat) {
        guard let gs = scene as? GameScene else { return }

        let star = SKSpriteNode(imageNamed: "blueStar")
        star.size = CGSize(width: 50, height: 50)
        let halfW = star.size.width/2
        star.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
        star.zPosition = 5
        star.blendMode = .alpha
        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
        star.physicsBody?.categoryBitMask = PhysicsCategory.blueStar
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false

        let planetPadding: CGFloat = 30
            for planet in gs.planets {
//                let lowBoundX = planet.position.x - planet.size.width/2 - planetPadding
//                let highBoundX = planet.position.x + planet.size.width/2 + planetPadding
//                let lowBoundY = planet.position.y - planet.size.height/2 - planetPadding
//                let highBoundY = planet.position.y + planet.size.height/2 + planetPadding
//                
//                if(star.position.x > lowBoundX && star.position.x < highBoundX){
//                    star.position.x = Int.random(in: 0...1) == 0 ? lowBoundX : highBoundX
//                }
//                
//                if(star.position.y > lowBoundY && star.position.y < highBoundY){
//                    star.position.y = Int.random(in: 0...1) == 0 ? lowBoundY : highBoundY
//                }
            }
        gs.blueStar.append(star)
        
        scene.addChild(star)
    }


    static func spawnFuel(in scene: GameScene, atY y: CGFloat) {
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


    static func spawnGate(in scene: GameScene, atY y: CGFloat) {
        let colors: [SKColor] = [.red, .green, .blue]
        let gateColors = [SKSpriteNode(imageNamed: "gateRed"), SKSpriteNode(imageNamed: "gateGreen"), SKSpriteNode(imageNamed: "gateBlue")]
        var randomIndexPoss = [0, 1, 2]
        if let currColorIndex = colors.firstIndex(of: scene.gateColor){
            randomIndexPoss.remove(at: currColorIndex)
        }
        let randomIndex = randomIndexPoss.randomElement()!
        let gate = gateColors[randomIndex]
        gate.color = colors[randomIndex]
//        gate.colorBlendFactor = 1.0
        
        print("Spawn a new gate")
        print(gate.color)
        gate.size = CGSize(width: scene.size.width, height: scene.size.height * 0.3)
        let halfW = gate.size.width / 2
        gate.position = CGPoint(
            x: halfW,
            y: y
        )
        gate.zPosition = 5
        
        let rectSize = CGSize(width: gate.size.width, height: gate.size.height * 0.001)
        let collisionRect = SKShapeNode(rectOf: rectSize, cornerRadius: 0)
        collisionRect.position    = .zero
        collisionRect.strokeColor = .clear    // untuk debug, tandanya
        collisionRect.lineWidth   = 2
        collisionRect.fillColor   = .clear
        collisionRect.zPosition   = -1       // di belakang gate
        
        let kiriSize = CGSize(width: gate.size.width/5.5, height: gate.size.height * 0.1)
        let kiri = SKShapeNode(rectOf: kiriSize, cornerRadius: 0)
        let kiriPositionX = -gate.size.width / 2 + kiriSize.width / 2
        kiri.position = CGPoint(x: kiriPositionX, y: 0)
        kiri.strokeColor = .clear    // untuk debug, tandanya
        kiri.lineWidth   = 5
        kiri.fillColor   = .clear
        kiri.zPosition   = -1       // di belakang gate
        
        let kananSize = CGSize(width: gate.size.width/5.5, height: gate.size.height * 0.1)
        let kanan = SKShapeNode(rectOf: kananSize, cornerRadius: 0)
        let kananPositionX = gate.size.width / 2 + -kananSize.width / 2
        kanan.position = CGPoint(x: kananPositionX, y: 0)
        kanan.strokeColor = .clear    // untuk debug, tandanya
        kanan.lineWidth   = 5
        kanan.fillColor   = .clear
        kanan.zPosition   = -1       // di belakang gate
        
        let body = SKPhysicsBody(rectangleOf: rectSize)
        body.isDynamic            = false
        
        let bodyKiri = SKPhysicsBody(rectangleOf: kiriSize)
        bodyKiri.isDynamic            = false
        
        let bodyKanan = SKPhysicsBody(rectangleOf: kananSize)
        bodyKanan.isDynamic            = false
        
        switch gate.color {
        case .red:
            body.categoryBitMask = PhysicsCategory.redGate
        case .green:
            body.categoryBitMask = PhysicsCategory.greenGate
        default:
            body.categoryBitMask = PhysicsCategory.blueGate
        }
        
        bodyKiri.categoryBitMask = PhysicsCategory.gateEdge
        bodyKanan.categoryBitMask = PhysicsCategory.gateEdge
        
        body.contactTestBitMask   = PhysicsCategory.Rocket
        body.collisionBitMask     = PhysicsCategory.None
        bodyKiri.contactTestBitMask   = PhysicsCategory.Rocket
        bodyKiri.collisionBitMask     = PhysicsCategory.None
        bodyKanan.contactTestBitMask   = PhysicsCategory.Rocket
        bodyKanan.collisionBitMask     = PhysicsCategory.None

        collisionRect.physicsBody = body
        kiri.physicsBody = bodyKiri
        kanan.physicsBody = bodyKanan
        
        gate.addChild(collisionRect)
        gate.addChild(kiri)
        gate.addChild(kanan)
        let gs = scene as GameScene
        gs.gate.append(gate)
        
        scene.addChild(gate)
        scene.upcomingGate = y
        scene.futureGate = y + scene.size.height +  500
        scene.gateColor = gate.color
        
        for _ in 0..<10 {
            StarSpawner.spawnStar(in: scene)            
        }
        
        print("Upcoming gate at \(y)")
    }
    static func spawnStarsBasedOnColor(in scene: GameScene) {
        let rocketColor = scene.rocket.color
        let starUnit = 5  // bisa disesuaikan
        var redStarUnit = 0, greenStarUnit = 0, blueStarUnit = 0

        if rocketColor == .red {
            redStarUnit = Int(Double(starUnit) * 0.75)
            let remaining = starUnit - redStarUnit
            greenStarUnit = Int.random(in: 0...remaining)
            blueStarUnit = remaining - greenStarUnit
        } else if rocketColor == .green {
            greenStarUnit = Int(Double(starUnit) * 0.75)
            let remaining = starUnit - greenStarUnit
            redStarUnit = Int.random(in: 0...remaining)
            blueStarUnit = remaining - redStarUnit
        } else {
            blueStarUnit = Int(Double(starUnit) * 0.75)
            let remaining = starUnit - blueStarUnit
            redStarUnit = Int.random(in: 0...remaining)
            greenStarUnit = remaining - redStarUnit
        }

        let startY: CGFloat = scene.size.height + 200
        let spacing: CGFloat = 100

        for i in 0..<redStarUnit   { spawnStar(in: scene, atY: startY + spacing * CGFloat(i)) }
        for i in 0..<greenStarUnit { spawnGreenStar(in: scene, atY: startY + spacing * CGFloat(i)) }
        for i in 0..<blueStarUnit  { spawnBlueStar(in: scene, atY: startY + spacing * CGFloat(i)) }
    }

    static func recycleOffscreen(in scene: GameScene, speed: CGFloat) {
        let offscreenY: CGFloat = -100, topY: CGFloat = scene.size.height + 10
        
        let planetUnitRandom = Int.random(in:3...5)
        var counter = 0
        
        scene.planets.shuffle()
        
        for (planetIdx, planet) in scene.planets.enumerated() {
            if planet.position.y / 2 < -planet.size.height / 2 {
                planet.position.y = topY + 500
                planet.position.x = getPlanetXPos(scene: scene, planet: planet, index: planetIdx)
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
        
        // LOGIC SPAWN STAR BASED ON ROCKET COLOUR
//        var rocketColor = scene.rocket.color
//        var redStarUnit = 0
//        var greenStarUnit = 0
//        var blueStarUnit = 0

//                if rocketColor == .red {
//                    redStarUnit = Int((Double(starUnit) * 0.75).rounded())
//                    let remaining = starUnit - redStarUnit
//                        if remaining > 0 {
//                            greenStarUnit = Int.random(in: 0...remaining)
//                            blueStarUnit = remaining - greenStarUnit
//                        }
//                } else if rocketColor == .green {
//                    greenStarUnit = Int((Double(starUnit) * 0.75).rounded())
//                       let remaining = starUnit - greenStarUnit
//                       
//                       if remaining > 0 {
//                           redStarUnit = Int.random(in: 0...remaining)
//                           blueStarUnit = remaining - redStarUnit
//                       }
//                } else {
//                    blueStarUnit = Int((Double(starUnit) * 0.75).rounded())
//                       let remaining = starUnit - blueStarUnit
//                       
//                       if remaining > 0 {
//                           redStarUnit = Int.random(in: 0...remaining)
//                           greenStarUnit = remaining - redStarUnit
//                       }
//                }
//
//        for star in scene.redStar {
//                    if star.size.width/2 >= (scene.size.width-star.size.width/2) {
//                        print("Issue in star! \(50 / 2) < \(scene.size.width-50/2)")
//                    }
//                    if star.position.y < offscreenY {
//                        star.position.x = CGFloat.random(in: star.size.width/2...(scene.size.width-star.size.width/2))
//                        star.position.y = topY + CGFloat.random(in: 0...200)
//                    }
//                    counter += 1
//                if counter == redStarUnit {
//                        counter = 0
//                        break
//                    }
//                }
//        for star in scene.greenStar {
//                    if star.size.width/2 >= (scene.size.width-star.size.width/2) {
//                        print("Issue in star! \(50 / 2) < \(scene.size.width-50/2)")
//                    }
//                    if star.position.y < offscreenY {
//                        star.position.x = CGFloat.random(in: star.size.width/2...(scene.size.width-star.size.width/2))
//                        star.position.y = topY + CGFloat.random(in: 0...200)
//                    }
//                    counter += 1
//            if counter == greenStarUnit {
//                        counter = 0
//                        break
//                    }
//                }
//        for star in scene.blueStar {
//                    if star.size.width/2 >= (scene.size.width-star.size.width/2) {
//                        print("Issue in star! \(50 / 2) < \(scene.size.width-50/2)")
//                    }
//                    if star.position.y < offscreenY {
//                        star.position.x = CGFloat.random(in: star.size.width/2...(scene.size.width-star.size.width/2))
//                        star.position.y = topY + CGFloat.random(in: 0...200)
//                    }
//                    counter += 1
//            if counter == blueStarUnit {
//                        counter = 0
//                        break
//                    }
//                }
//        print(blueStarUnit)


        scene.gate.forEach { g in
            if g.position.y < offscreenY {
                scene.gate.removeAll()
                spawnGate(in: scene, atY: scene.futureGate)
                g.position.x = CGFloat.random(in: g.size.width/2...(scene.size.width-g.size.width/2))
            }
        }
        
//        if(scene.isPowerupSpawned){
//            spawnPowerup(in: scene, y: scene.position.y)
//            scene.isPowerupSpawned = false
//        }
    }
}
