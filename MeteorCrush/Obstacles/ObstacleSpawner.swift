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
    static func spawnPlanet(in scene: SKScene, atY y: CGFloat) {
            let planet = SKSpriteNode(imageNamed: "planet")
            let randomSize = CGFloat.random(in: 10...10)
            planet.size = CGSize(width: randomSize, height: randomSize)
            let halfW = planet.size.width / 2
            let maxOutsideFraction: CGFloat = 0.3
            let offset = planet.size.width * maxOutsideFraction

            let newX = CGFloat.random(in: -offset...(scene.size.width + offset))
            let newY = y

            // ➤ Cek jarak dengan planet yang sudah ada
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
    
//    static func spawnStar(in scene: SKScene, atY y: CGFloat) {
//        guard let gs = scene as? GameScene else { return }
//        var starPicker = ""
//
//        // Fungsi helper untuk weighted random selection
//        func randomWeightedElement<T>(_ elements: [(element: T, weight: Double)]) -> T? {
//            let totalWeight = elements.reduce(0) { $0 + $1.weight }
//            let r = Double.random(in: 0..<totalWeight)
//            var cumWeight: Double = 0
//            for item in elements {
//                cumWeight += item.weight
//                if r < cumWeight {
//                    return item.element
//                }
//            }
//            return nil
//        }
//
//        let rocketColor = gs.rocket.color
//        if rocketColor == .red {
//            // Misal: 75% red, 12.5% green, 12.5% blue
//            let starOptions: [(String, Double)] = [
//                ("redStar",   0.75),
//                ("greenStar", 0.125),
//                ("blueStar",  0.125)
//            ]
//            if let pick = randomWeightedElement(starOptions) {
//                starPicker = pick
//            }
//        } else if rocketColor == .green {
//            // Misal: 60% green, 20% red, 20% blue
//            let starOptions: [(String, Double)] = [
//                ("greenStar", 0.60),
//                ("redStar",   0.20),
//                ("blueStar",  0.20)
//            ]
//            if let pick = randomWeightedElement(starOptions) {
//                starPicker = pick
//            }
//        } else {
//            // Default (misal): peluang sama untuk semua
//            let starColors = ["redStar", "greenStar", "blueStar"]
//            starPicker = starColors.randomElement()!
//        }
//
//        let star = SKSpriteNode(imageNamed: starPicker)
//        star.size = CGSize(width: 50, height: 50)
//        let halfW = star.size.width/2
//        star.position = CGPoint(x: CGFloat.random(in: halfW...(scene.size.width-halfW)), y: y)
//        star.zPosition = 5
//        star.blendMode = .alpha
//        star.physicsBody = SKPhysicsBody(circleOfRadius: halfW)
//        if starPicker == "redStar"
//        {
//            star.physicsBody?.categoryBitMask = PhysicsCategory.redStar
//        } else if starPicker == "greenStar"
//        {
//            star.physicsBody?.categoryBitMask = PhysicsCategory.greenStar
//        } else
//        {
//            star.physicsBody?.categoryBitMask = PhysicsCategory.blueStar
//        }
//        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
//        star.physicsBody?.collisionBitMask = PhysicsCategory.None
//        star.physicsBody?.affectedByGravity = false
//
//        let planetPadding: CGFloat = 30
//            for planet in gs.planets {
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
//            }
//            gs.stars.append(star)
//        
//        scene.addChild(star)
//    }
    
    static func spawnRedStar(in scene: SKScene, atY y: CGFloat) {
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
        gs.redStar.append(star)
        
        scene.addChild(star)
    }
    static func spawnGreenStar(in scene: SKScene, atY y: CGFloat) {
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
        gs.greenStar.append(star)
        
        scene.addChild(star)
    }
    static func spawnBlueStar(in scene: SKScene, atY y: CGFloat) {
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
        gs.blueStar.append(star)
        
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
        let randomIndex = Int.random(in: 0...2)
        gate.color = colors[randomIndex]
        gate.colorBlendFactor = 1.0
        
        print("Spawn a new gate")
        print(gate.color)
        gate.size = CGSize(width: scene.size.width * 1, height: scene.size.height * 0.3)
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

        for i in 0..<redStarUnit   { spawnRedStar(in: scene, atY: startY + spacing * CGFloat(i)) }
        for i in 0..<greenStarUnit { spawnGreenStar(in: scene, atY: startY + spacing * CGFloat(i)) }
        for i in 0..<blueStarUnit  { spawnBlueStar(in: scene, atY: startY + spacing * CGFloat(i)) }
    }

    static func recycleOffscreen(in scene: GameScene, speed: CGFloat) {
        let offscreenY: CGFloat = -100, topY: CGFloat = scene.size.height + 10
        
        // PLANET DLL DIBKIN 100 JENIS, AMBIL BBRP AJA (RANDOM) :)
        // FUELNYA DIRANDOM DISINI 0-1 (belom)
        
        var planetUnitRandom = Int.random(in:3...5)
        var starUnit = planetUnitRandom * 2 - 1
        var counter = 0
        
        scene.planets.shuffle()
        
        for planet in scene.planets {
            if planet.position.y < offscreenY {
                planet.position.y = topY + CGFloat.random(in: 0...200)
                planet.position.x = CGFloat.random(
                    in: planet.size.width/2 ...
                        (scene.size.width - planet.size.width/2)
                )
                counter += 1
                if counter == planetUnitRandom {
                    counter = 0
                    break
                }
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
        var rocketColor = scene.rocket.color
        var redStarUnit = 0
        var greenStarUnit = 0
        var blueStarUnit = 0

                if rocketColor == .red {
                    redStarUnit = Int((Double(starUnit) * 0.75).rounded())
                    let remaining = starUnit - redStarUnit
                        if remaining > 0 {
                            greenStarUnit = Int.random(in: 0...remaining)
                            blueStarUnit = remaining - greenStarUnit
                        }
                } else if rocketColor == .green {
                    greenStarUnit = Int((Double(starUnit) * 0.75).rounded())
                       let remaining = starUnit - greenStarUnit
                       
                       if remaining > 0 {
                           redStarUnit = Int.random(in: 0...remaining)
                           blueStarUnit = remaining - redStarUnit
                       }
                } else {
                    blueStarUnit = Int((Double(starUnit) * 0.75).rounded())
                       let remaining = starUnit - blueStarUnit
                       
                       if remaining > 0 {
                           redStarUnit = Int.random(in: 0...remaining)
                           greenStarUnit = remaining - redStarUnit
                       }
                }

        for star in scene.redStar {
                    if star.size.width/2 >= (scene.size.width-star.size.width/2) {
                        print("Issue in star! \(50 / 2) < \(scene.size.width-50/2)")
                    }
                    if star.position.y < offscreenY {
                        star.position.x = CGFloat.random(in: star.size.width/2...(scene.size.width-star.size.width/2))
                        star.position.y = topY + CGFloat.random(in: 0...200)
                    }
                    counter += 1
                if counter == redStarUnit {
                        counter = 0
                        break
                    }
                }
        for star in scene.greenStar {
                    if star.size.width/2 >= (scene.size.width-star.size.width/2) {
                        print("Issue in star! \(50 / 2) < \(scene.size.width-50/2)")
                    }
                    if star.position.y < offscreenY {
                        star.position.x = CGFloat.random(in: star.size.width/2...(scene.size.width-star.size.width/2))
                        star.position.y = topY + CGFloat.random(in: 0...200)
                    }
                    counter += 1
            if counter == greenStarUnit {
                        counter = 0
                        break
                    }
                }
        for star in scene.blueStar {
                    if star.size.width/2 >= (scene.size.width-star.size.width/2) {
                        print("Issue in star! \(50 / 2) < \(scene.size.width-50/2)")
                    }
                    if star.position.y < offscreenY {
                        star.position.x = CGFloat.random(in: star.size.width/2...(scene.size.width-star.size.width/2))
                        star.position.y = topY + CGFloat.random(in: 0...200)
                    }
                    counter += 1
            if counter == blueStarUnit {
                        counter = 0
                        break
                    }
                }
        print(blueStarUnit)


        scene.gate.forEach { g in
            if g.position.y < offscreenY {
                scene.gate.removeAll()
                spawnGate(in: scene, atY: topY + CGFloat.random(in: 0...200))
                g.position.x = CGFloat.random(in: g.size.width/2...(scene.size.width-g.size.width/2))
            }
        }
    }
}
