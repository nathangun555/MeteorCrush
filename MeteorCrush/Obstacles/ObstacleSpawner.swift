//
//  ObstacleSpawner.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit

struct ObstacleSpawner { 
    var lastPlanetPos = 0
    
    static func circlesCollide(center1: CGPoint, radius1: CGFloat,
                               center2: CGPoint, radius2: CGFloat) -> Bool {
               let dx = center2.x - center1.x
               let dy = center2.y - center1.y
               let distanceSquared = dx * dx + dy * dy
               let radiusSum = radius1 + radius2
               
               return distanceSquared <= radiusSum * radiusSum
           }
    
    // Helper function to check if a new object collides with existing collectibles
    static func checkCollisionWithCollectibles(in scene: GameScene, position: CGPoint, radius: CGFloat) -> Bool {
        // Check collision with red stars
        for star in scene.redStar {
            let starRadius = star.size.width / 3.5
            if circlesCollide(center1: position, radius1: radius, 
                            center2: star.position, radius2: starRadius) {
                return true
            }
        }
        
        // Check collision with green stars
        for star in scene.greenStar {
            let starRadius = star.size.width / 3.5
            if circlesCollide(center1: position, radius1: radius, 
                            center2: star.position, radius2: starRadius) {
                return true
            }
        }
        
        // Check collision with blue stars
        for star in scene.blueStar {
            let starRadius = star.size.width / 3.5
            if circlesCollide(center1: position, radius1: radius, 
                            center2: star.position, radius2: starRadius) {
                return true
            }
        }
        
        // Check collision with fuels
        for fuel in scene.fuels {
            let fuelRadius = fuel.size.width / 3.5
            if circlesCollide(center1: position, radius1: radius, 
                            center2: fuel.position, radius2: fuelRadius) {
                return true
            }
        }
        
        // Check collision with powerups
        for powerup in scene.powerups {
            let powerupRadius = powerup.size.width / 6
            if circlesCollide(center1: position, radius1: radius, 
                            center2: powerup.position, radius2: powerupRadius) {
                return true
            }
        }
        
        // Check collision with planets
        for planet in scene.planets {
            let planetRadius = planet.size.width / 3 // Using collision radius from planet spawn
            if circlesCollide(center1: position, radius1: radius, 
                            center2: planet.position, radius2: planetRadius) {
                return true
            }
        }
        
        return false
    }
    
    // Helper function to find a valid position for collectibles
    static func findValidPosition(in scene: GameScene, y: CGFloat, radius: CGFloat, maxAttempts: Int = 50) -> CGPoint? {
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
    
    // Function to remove colliding objects from the scene
    static func removeCollidingObjects(in scene: GameScene) {
        // Check for collisions between red stars and other collectibles
        scene.redStar = scene.redStar.filter { star in
            let starRadius = star.size.width / 3.5
            let starPosition = star.position
            
            // Check collision with other red stars
            for otherStar in scene.redStar {
                if otherStar !== star {
                    let otherRadius = otherStar.size.width / 3.5
                    if circlesCollide(center1: starPosition, radius1: starRadius, 
                                    center2: otherStar.position, radius2: otherRadius) {
                        star.removeFromParent()
                        return false
                    }
                }
            }
            
            // Check collision with green stars
            for greenStar in scene.greenStar {
                let greenRadius = greenStar.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: greenStar.position, radius2: greenRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with blue stars
            for blueStar in scene.blueStar {
                let blueRadius = blueStar.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: blueStar.position, radius2: blueRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with fuels
            for fuel in scene.fuels {
                let fuelRadius = fuel.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: fuel.position, radius2: fuelRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with powerups
            for powerup in scene.powerups {
                let powerupRadius = powerup.size.width / 6
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: powerup.position, radius2: powerupRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with planets
            for planet in scene.planets {
                let planetRadius = planet.size.width / 3
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: planet.position, radius2: planetRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            return true
        }
        
        // Check for collisions between green stars and other collectibles
        scene.greenStar = scene.greenStar.filter { star in
            let starRadius = star.size.width / 3.5
            let starPosition = star.position
            
            // Check collision with red stars
            for redStar in scene.redStar {
                let redRadius = redStar.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: redStar.position, radius2: redRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with other green stars
            for otherStar in scene.greenStar {
                if otherStar !== star {
                    let otherRadius = otherStar.size.width / 3.5
                    if circlesCollide(center1: starPosition, radius1: starRadius, 
                                    center2: otherStar.position, radius2: otherRadius) {
                        star.removeFromParent()
                        return false
                    }
                }
            }
            
            // Check collision with blue stars
            for blueStar in scene.blueStar {
                let blueRadius = blueStar.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: blueStar.position, radius2: blueRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with fuels
            for fuel in scene.fuels {
                let fuelRadius = fuel.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: fuel.position, radius2: fuelRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with powerups
            for powerup in scene.powerups {
                let powerupRadius = powerup.size.width / 6
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: powerup.position, radius2: powerupRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with planets
            for planet in scene.planets {
                let planetRadius = planet.size.width / 3
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: planet.position, radius2: planetRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            return true
        }
        
        // Check for collisions between blue stars and other collectibles
        scene.blueStar = scene.blueStar.filter { star in
            let starRadius = star.size.width / 3.5
            let starPosition = star.position
            
            // Check collision with red stars
            for redStar in scene.redStar {
                let redRadius = redStar.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: redStar.position, radius2: redRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with green stars
            for greenStar in scene.greenStar {
                let greenRadius = greenStar.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: greenStar.position, radius2: greenRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with other blue stars
            for otherStar in scene.blueStar {
                if otherStar !== star {
                    let otherRadius = otherStar.size.width / 3.5
                    if circlesCollide(center1: starPosition, radius1: starRadius, 
                                    center2: otherStar.position, radius2: otherRadius) {
                        star.removeFromParent()
                        return false
                    }
                }
            }
            
            // Check collision with fuels
            for fuel in scene.fuels {
                let fuelRadius = fuel.size.width / 3.5
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: fuel.position, radius2: fuelRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with powerups
            for powerup in scene.powerups {
                let powerupRadius = powerup.size.width / 6
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: powerup.position, radius2: powerupRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            // Check collision with planets
            for planet in scene.planets {
                let planetRadius = planet.size.width / 3
                if circlesCollide(center1: starPosition, radius1: starRadius, 
                                center2: planet.position, radius2: planetRadius) {
                    star.removeFromParent()
                    return false
                }
            }
            
            return true
        }
        
        // Check for collisions between fuels and other collectibles
        scene.fuels = scene.fuels.filter { fuel in
            let fuelRadius = fuel.size.width / 3.5
            let fuelPosition = fuel.position
            
            // Check collision with red stars
            for redStar in scene.redStar {
                let redRadius = redStar.size.width / 3.5
                if circlesCollide(center1: fuelPosition, radius1: fuelRadius, 
                                center2: redStar.position, radius2: redRadius) {
                    fuel.removeFromParent()
                    return false
                }
            }
            
            // Check collision with green stars
            for greenStar in scene.greenStar {
                let greenRadius = greenStar.size.width / 3.5
                if circlesCollide(center1: fuelPosition, radius1: fuelRadius, 
                                center2: greenStar.position, radius2: greenRadius) {
                    fuel.removeFromParent()
                    return false
                }
            }
            
            // Check collision with blue stars
            for blueStar in scene.blueStar {
                let blueRadius = blueStar.size.width / 3.5
                if circlesCollide(center1: fuelPosition, radius1: fuelRadius, 
                                center2: blueStar.position, radius2: blueRadius) {
                    fuel.removeFromParent()
                    return false
                }
            }
            
            // Check collision with other fuels
            for otherFuel in scene.fuels {
                if otherFuel !== fuel {
                    let otherRadius = otherFuel.size.width / 3.5
                    if circlesCollide(center1: fuelPosition, radius1: fuelRadius, 
                                    center2: otherFuel.position, radius2: otherRadius) {
                        fuel.removeFromParent()
                        return false
                    }
                }
            }
            
            // Check collision with powerups
            for powerup in scene.powerups {
                let powerupRadius = powerup.size.width / 6
                if circlesCollide(center1: fuelPosition, radius1: fuelRadius, 
                                center2: powerup.position, radius2: powerupRadius) {
                    fuel.removeFromParent()
                    return false
                }
            }
            
            // Check collision with planets
            for planet in scene.planets {
                let planetRadius = planet.size.width / 3
                if circlesCollide(center1: fuelPosition, radius1: fuelRadius, 
                                center2: planet.position, radius2: planetRadius) {
                    fuel.removeFromParent()
                    return false
                }
            }
            
            return true
        }
        
        // Check for collisions between powerups and other collectibles
        scene.powerups = scene.powerups.filter { powerup in
            let powerupRadius = powerup.size.width / 6
            let powerupPosition = powerup.position
            
            // Check collision with red stars
            for redStar in scene.redStar {
                let redRadius = redStar.size.width / 3.5
                if circlesCollide(center1: powerupPosition, radius1: powerupRadius, 
                                center2: redStar.position, radius2: redRadius) {
                    powerup.removeFromParent()
                    return false
                }
            }
            
            // Check collision with green stars
            for greenStar in scene.greenStar {
                let greenRadius = greenStar.size.width / 3.5
                if circlesCollide(center1: powerupPosition, radius1: powerupRadius, 
                                center2: greenStar.position, radius2: greenRadius) {
                    powerup.removeFromParent()
                    return false
                }
            }
            
            // Check collision with blue stars
            for blueStar in scene.blueStar {
                let blueRadius = blueStar.size.width / 3.5
                if circlesCollide(center1: powerupPosition, radius1: powerupRadius, 
                                center2: blueStar.position, radius2: blueRadius) {
                    powerup.removeFromParent()
                    return false
                }
            }
            
            // Check collision with fuels
            for fuel in scene.fuels {
                let fuelRadius = fuel.size.width / 3.5
                if circlesCollide(center1: powerupPosition, radius1: powerupRadius, 
                                center2: fuel.position, radius2: fuelRadius) {
                    powerup.removeFromParent()
                    return false
                }
            }
            
            // Check collision with other powerups
            for otherPowerup in scene.powerups {
                if otherPowerup !== powerup {
                    let otherRadius = otherPowerup.size.width / 6
                    if circlesCollide(center1: powerupPosition, radius1: powerupRadius, 
                                    center2: otherPowerup.position, radius2: otherRadius) {
                        powerup.removeFromParent()
                        return false
                    }
                }
            }
            
            // Check collision with planets
            for planet in scene.planets {
                let planetRadius = planet.size.width / 3
                if circlesCollide(center1: powerupPosition, radius1: powerupRadius, 
                                center2: planet.position, radius2: planetRadius) {
                    powerup.removeFromParent()
                    return false
                }
            }
            
            return true
        }
    }
    
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
    
    static func getNextPlanetXPos(scene: GameScene, planet: SKSpriteNode) -> CGFloat {
        let planetPosType = scene.planetIndex % 2
        var upperBoundX: CGFloat = 0.0, lowerBoundX: CGFloat = 0.0
        
        if planetPosType == 0 {
            // 0 = kanan
            upperBoundX = scene.size.width + planet.size.width / 2 - 100
            lowerBoundX = scene.size.width
            print("Recycled Kanan")
        } else {
            // 1 = kiri
            lowerBoundX = -planet.size.width / 2 + 100
            upperBoundX = 0.0
            print("Recycled Kiri")
        }
        
        scene.planetIndex += 1
        return CGFloat.random(in: lowerBoundX...upperBoundX)
    }
    
    static func spawnPlanet(in scene: GameScene, atY y: CGFloat, index: Int) {
        let planets = [SKSpriteNode(imageNamed: "planet1"), SKSpriteNode(imageNamed: "planet2"), SKSpriteNode(imageNamed: "planet3"), SKSpriteNode(imageNamed: "planet4"), SKSpriteNode(imageNamed: "planet5"), SKSpriteNode(imageNamed: "planet6")]
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

        let star = SKSpriteNode(imageNamed: "starRed")
        star.size = CGSize(width: 180, height: 180)
        let halfW = star.size.width/2
        let collisionRadius = halfW / 3.5
        
        // Find a valid position that doesn't collide with other collectibles
        guard let validPosition = findValidPosition(in: scene, y: y, radius: collisionRadius) else {
            return // Skip spawning if no valid position found
        }
        
        star.position = validPosition
        star.zPosition = 5
        star.blendMode = .alpha
        
        star.physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius)
        star.physicsBody?.categoryBitMask = PhysicsCategory.redStar
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false
        
        let collisionCircle = SKShapeNode(circleOfRadius: collisionRadius)
        collisionCircle.position = .zero
        collisionCircle.strokeColor = .clear
        collisionCircle.lineWidth = 2
        collisionCircle.fillColor = .clear
        collisionCircle.zPosition = -1
        star.addChild(collisionCircle)

        gs.redStar.append(star)
        scene.addChild(star)
    }
    static func spawnGreenStar(in scene: GameScene, atY y: CGFloat) {
        guard let gs = scene as? GameScene else { return }

        let star = SKSpriteNode(imageNamed: "starGreen")
        star.size = CGSize(width: 180, height: 180)
        let halfW = star.size.width/2
        let collisionRadius = halfW / 3.5
        
        // Find a valid position that doesn't collide with other collectibles
        guard let validPosition = findValidPosition(in: scene, y: y, radius: collisionRadius) else {
            return // Skip spawning if no valid position found
        }
        
        star.position = validPosition
        star.zPosition = 5
        star.blendMode = .alpha
        
        star.physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius)
        star.physicsBody?.categoryBitMask = PhysicsCategory.greenStar
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false

        // Tambahkan indikator visual (tanpa physicsBody lagi)
        let collisionCircle = SKShapeNode(circleOfRadius: collisionRadius)
        collisionCircle.position = .zero
        collisionCircle.strokeColor = .clear
        collisionCircle.lineWidth = 2
        collisionCircle.fillColor = .clear
        collisionCircle.zPosition = -1
        star.addChild(collisionCircle)

        gs.greenStar.append(star)
        scene.addChild(star)
    }
    static func spawnBlueStar(in scene: GameScene, atY y: CGFloat) {
        guard let gs = scene as? GameScene else { return }

        let star = SKSpriteNode(imageNamed: "starBlue")
        star.size = CGSize(width: 180, height: 180)
        let halfW = star.size.width/2
        let collisionRadius = halfW / 3.5
        
        // Find a valid position that doesn't collide with other collectibles
        guard let validPosition = findValidPosition(in: scene, y: y, radius: collisionRadius) else {
            return // Skip spawning if no valid position found
        }
        
        star.position = validPosition
        star.zPosition = 5
        star.blendMode = .alpha

        star.physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius)
        star.physicsBody?.categoryBitMask = PhysicsCategory.blueStar
        star.physicsBody?.contactTestBitMask = PhysicsCategory.Rocket
        star.physicsBody?.collisionBitMask = PhysicsCategory.None
        star.physicsBody?.affectedByGravity = false

        // Tambahkan indikator visual (tanpa physicsBody lagi)
        let collisionCircle = SKShapeNode(circleOfRadius: collisionRadius)
        collisionCircle.position = .zero
        collisionCircle.strokeColor = .clear
        collisionCircle.lineWidth = 2
        collisionCircle.fillColor = .clear
        collisionCircle.zPosition = -1
        star.addChild(collisionCircle)

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
        let collisionRadius = halfW / 3.5
        
        // Find a valid position that doesn't collide with other collectibles
        guard let validPosition = findValidPosition(in: scene, y: y, radius: collisionRadius) else {
            return // Skip spawning if no valid position found
        }
        
        pickup.position = validPosition
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
        var newY: CGFloat = y
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
        
        for planet in scene.planets {
            let planetUpperBound: CGFloat = planet.position.y + planet.size.height / 2
            let planetLowerBound: CGFloat = planet.position.y - planet.size.height / 2
            
            if(y >= planetUpperBound || y <= planetLowerBound){
                newY = planetUpperBound + 50
            }
        }
        
        print("Spawn a new gate")
        print(gate.color)
        gate.size = CGSize(width: scene.size.width + 7, height: scene.size.height * 0.3)
        let halfW = gate.size.width / 2
        gate.position = CGPoint(
            x: halfW-4,
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
        
        // Don't shuffle planets to maintain alternating pattern
        // scene.planets.shuffle()
        
        for planet in scene.planets {
            if planet.position.y / 2 < -planet.size.height / 2 {
                planet.position.y = topY + 500
                planet.position.x = getNextPlanetXPos(scene: scene, planet: planet)
            }
        }
        
                scene.fuels.forEach { f in
                    if 25 >= (scene.size.width-25) {
                        print("Issue in fuel! \(25) < \(scene.size.width-25)")
                    }
        //            print(f.size.width / 2, scene.size.width - f.size.width / 2)
                    if f.position.y < offscreenY {
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
        


        scene.gate.forEach { g in
            if g.position.y < offscreenY {
                scene.gate.removeAll()
                spawnGate(in: scene, atY: scene.futureGate)
//                g.position.x = CGFloat.random(in: g.size.width/2...(scene.size.width-g.size.width/2))
            }
        }
    }
}
