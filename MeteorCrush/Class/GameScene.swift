//
//  GameScene.swift
//  MeteorCrush
//
//  Created by Vivi on 11/07/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var rocket: SKSpriteNode!
    private var joystick: Joystick!
    private var hud: HUD!
    
    var planets   = [SKSpriteNode]()
  //  var stars     = [SKSpriteNode]()
    var redStar     = [SKSpriteNode]()
    var greenStar     = [SKSpriteNode]()
    var blueStar     = [SKSpriteNode]()
    var fuels     = [SKSpriteNode]()
    var gate      = [SKSpriteNode]()
    var fireNode: SKSpriteNode!
    var distance: Int = 0
    
    private var planetCount = 100
    private var starCount   = 100
    private var fuelCount   = 1
    private var gateCount   = 1
    
    private var scrollSpeed: CGFloat = 3.0
    private var rocketY: CGFloat = 0
    
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .brown
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        setupRocket()
        setupJoystick()
        setupHUD()
        spawnInitialObstacles()
        let consume = SKAction.run { [weak self] in
            guard let self = self, !self.isGameOver else { return }
            self.hud.fuel -= 1
            self.distance += 1
//            print(self.distance)
            if(self.distance % 5*5 == 0){
                self.scrollSpeed += 0.1
//                print("Increasing speed to \(self.scrollSpeed)")
            }
            self.hud.updateLabels()
            if self.hud.fuel <= 0 {
                NotificationCenter.default.post(
                    name: Notification.Name("GameOver"),
                    object: hud.score
                )
                self.removeAction(forKey: "fuelTimer")
                
                // 3 (opsional) panggil gameOver sequence/method
                isGameOver = true
            }
        }
        let wait = SKAction.wait(forDuration: 0.2)
        let sequence = SKAction.sequence([wait, consume])
        let repeatForever = SKAction.repeatForever(sequence)
        run(repeatForever, withKey: "fuelTimer")
    }
    
    private func setupRocket() {
        let randomRocket = ["rocketPink", "rocketGreen", "rocketBlue"]
        let rocketPicker = randomRocket.randomElement()!
        rocket = SKSpriteNode(imageNamed: rocketPicker)
        rocket.size = CGSize(width: 100, height: 100)
        rocketY = size.height / 4
        rocket.position = CGPoint(x: size.width/2, y: rocketY)
        rocket.zPosition = 10
        if rocketPicker == "rocketPink" {
            rocket.color = .red
        } else  if rocketPicker == "rocketGreen" {
            rocket.color = .green
        } else {
            rocket.color = .blue
        }
        if let tex = rocket.texture {
            rocket.physicsBody = SKPhysicsBody(texture: tex, size: rocket.size)
            rocket.physicsBody?.categoryBitMask = PhysicsCategory.Rocket
            rocket.physicsBody?.contactTestBitMask = PhysicsCategory.Planet | PhysicsCategory.redStar | PhysicsCategory.blueStar | PhysicsCategory.greenStar | PhysicsCategory.Fuel
            rocket.physicsBody?.collisionBitMask = PhysicsCategory.None
            rocket.physicsBody?.affectedByGravity = false
        }
        
        fireNode = SKSpriteNode(imageNamed: "fire1")
        fireNode.size = CGSize(width: 40, height: 60)
        fireNode.position = CGPoint(x: 0, y: -rocket.size.height/1.25)
        fireNode.zPosition = 99
        rocket.addChild(fireNode)

        addChild(rocket)
    }
    
    func changeRocketColor(_ color: UIColor)    {
        rocket.color = color
        rocket.colorBlendFactor = 1  // 1.0 = full tint
    }
    
    private func setupJoystick() {
        joystick = Joystick()
        addChild(joystick)
    }
    
    private func setupHUD() {
        hud = HUD(size: size)
        addChild(hud)
    }
    
    public func spawnInitialObstacles() {
        var planetUnitRandom = Int.random(in:3...5)
        var starUnit = planetUnitRandom * 2 - 1
        var counter = 0
        
        let startY: CGFloat = size.height * 0.8 // Mulai dari 80% tinggi layar
        let planetSpacing = size.height / CGFloat(planetUnitRandom)
        for i in 0..<planetUnitRandom {
            ObstacleSpawner.spawnPlanet(in: self, atY: startY + CGFloat(i) * planetSpacing)
        }
        let starSpacing = size.height / CGFloat(starUnit)
        // LOGIC STAR ROCKET DISINI
        let rocketColor = rocket.color
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
        for i in 0..<redStarUnit     { ObstacleSpawner.spawnRedStar(in: self, atY: startY + CGFloat(i) * starSpacing + 100) }
        for i in 0..<greenStarUnit     { ObstacleSpawner.spawnGreenStar(in: self, atY: startY + CGFloat(i) * starSpacing + 100) }
        for i in 0..<blueStarUnit     { ObstacleSpawner.spawnBlueStar(in: self, atY: startY + CGFloat(i) * starSpacing + 100) }
//        for i in 0..<starUnit     { ObstacleSpawner.spawnStar(in: self, atY: startY + CGFloat(i) * starSpacing + 100) }
        let fuelSpacing = size.height / CGFloat(fuelCount)
        for i in 0..<fuelCount     { ObstacleSpawner.spawnFuel(in: self, atY: startY + CGFloat(i) * fuelSpacing + 200)
        }
        let gateSpacing = size.height / CGFloat(gateCount)
        for i in 0..<gateCount     { ObstacleSpawner.spawnGate(in: self, atY: startY + CGFloat(i) * gateSpacing + 200)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { joystick.begin(at: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first { joystick.move(to: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.end(rocket)
    }
    
    override func update(_ currentTime: TimeInterval) {
        planets.forEach { $0.position.y -= scrollSpeed }
        redStar.forEach   { $0.position.y -= scrollSpeed }
        greenStar.forEach   { $0.position.y -= scrollSpeed }
        blueStar.forEach   { $0.position.y -= scrollSpeed }
        fuels.forEach   { $0.position.y -= scrollSpeed }
        gate.forEach   { $0.position.y -= scrollSpeed }
        
        guard !isGameOver else {
            removeAction(forKey: "fuelTimer")
            return
        }
        joystick.updateRocket(rocket, fuel: &hud.fuel, rocketY: &rocketY) // bensinnya berkurang
        updateFireEffect()
        hud.updateLabels()
        ObstacleSpawner.recycleOffscreen(in: self, speed: scrollSpeed)
        
    }
    
    func updateFireEffect() {
        guard hud.fuel > 0 else {
            fireNode.isHidden = true
            return
        }

        fireNode.isHidden = false

        switch hud.fuel {
        case 75...100:
            fireNode.texture = SKTexture(imageNamed: "fire1")
        case 30..<75:
            fireNode.texture = SKTexture(imageNamed: "fire2")
        case 1..<30:
            fireNode.texture = SKTexture(imageNamed: "fire3")
        default:
            fireNode.isHidden = true
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        CollisionHandler.handle(contact, in: self, hud: hud)
    }
}
